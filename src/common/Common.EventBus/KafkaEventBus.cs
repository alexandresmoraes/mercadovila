using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;
using Common.EventBus.Utils;
using Confluent.Kafka;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Polly;
using Polly.Wrap;
using System.Text.Json;

namespace Common.EventBus
{
  public class KafkaEventBus : IEventBus, IDisposable
  {
    private readonly ILogger<KafkaEventBus> _logger;
    private readonly EventBusSettings _eventBusSettings;
    private readonly IServiceProvider _serviceProvider;
    private readonly IEventBusSubscriptionsManager _subsManager;
    private readonly AsyncPolicyWrap _policyWrap;
    private readonly IProducer<string, string> _producer;
    private readonly IConsumer<string, string> _consumer;
    private readonly int _retryCount;

    public KafkaEventBus(
      ILogger<KafkaEventBus> logger,
      EventBusSettings eventBusSettings,
      IServiceProvider serviceProvider,
      IEventBusSubscriptionsManager subsManager,
      int retryCount = 5)
    {
      _logger = logger;
      _eventBusSettings = eventBusSettings;
      _serviceProvider = serviceProvider;
      _subsManager = subsManager;
      _retryCount = retryCount;

      var retryPolicy = Policy
            .Handle<Exception>()
            .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));

      var circuitBreakerPolicy = Policy
          .Handle<Exception>()
          .CircuitBreakerAsync(3, TimeSpan.FromMinutes(1), OnBreak, OnReset, OnHalfOpen);

      _policyWrap = Policy.WrapAsync(retryPolicy, circuitBreakerPolicy);

      var producerConfig = new ProducerConfig
      {
        BootstrapServers = eventBusSettings.BootstrapServer
      };
      _producer = new ProducerBuilder<string, string>(producerConfig).Build();

      var consumerConfig = new ConsumerConfig
      {
        BootstrapServers = eventBusSettings.BootstrapServer,
        GroupId = eventBusSettings.Group,
        AutoOffsetReset = AutoOffsetReset.Earliest
      };
      _consumer = new ConsumerBuilder<string, string>(consumerConfig).Build();
    }

    public async Task PublishAsync(IntegrationEvent @event)
    {
      var policy = Policy.Handle<Exception>()
       .WaitAndRetryAsync(_retryCount, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)), (ex, time) =>
       {
         _logger.LogWarning(ex, "Could not publish event: {EventId} after {Timeout}s ({ExceptionMessage})", @event.Id, $"{time.TotalSeconds:n1}", ex.Message);
       });

      var eventName = @event.GetType().Name;

      _logger.LogTrace("Creating Kafka producer to publish event: {EventId} ({EventName})", @event.Id, eventName);

      var message = JsonSerializer.Serialize(@event, @event.GetType());

      await policy.ExecuteAsync(async () =>
      {
        _logger.LogTrace("Publishing event to Kafka: {EventId}", @event.Id);

        await _producer.ProduceAsync(_eventBusSettings.Topic, new Message<string, string>
        {
          Key = @event.Key ?? Guid.NewGuid().ToString(),
          Value = message
        });
      });
    }

    public void Subscribe<T, TH>()
      where T : IntegrationEvent
      where TH : IIntegrationEventHandler<T>
    {
      var eventName = _subsManager.GetEventKey<T>();

      _logger.LogInformation("Subscribing to event {EventName} with {EventHandler}", eventName, typeof(TH).GetGenericTypeName());

      _subsManager.AddSubscription<T, TH>();
      StartBasicConsume(eventName);
    }

    public void Unsubscribe<T, TH>()
      where T : IntegrationEvent
      where TH : IIntegrationEventHandler<T>
    {
      var eventName = _subsManager.GetEventKey<T>();

      _logger.LogInformation("Unsubscribing from event {EventName}", eventName);

      _subsManager.RemoveSubscription<T, TH>();
    }

    private void StartBasicConsume(string eventName)
    {
      _logger.LogTrace("Starting Kafka basic consume");

      Task.Run(async () =>
      {
        _consumer.Subscribe(_eventBusSettings.Topic);

        while (true)
        {
          try
          {
            var result = _consumer.Consume();

            if (result is not null)
            {
              _logger.LogInformation("Consumer event started partition: {partition} offset: {offset} timestamp: {timestamp}",
                result.Partition,
                result.Offset,
                result.Message.Timestamp.UtcDateTime);

              await _policyWrap.ExecuteAsync(async () =>
              {
                await ProcessEvent(eventName, result.Message.Value);
              });
            }
          }
          catch (Exception ex)
          {
            _logger.LogError(ex, "----- ERROR Processing event \"{@eventName}\"", eventName);
          }
        }
      });
    }

    private async Task ProcessEvent(string eventName, string message)
    {
      _logger.LogTrace("Processing Kafka event: {EventName}", eventName);

      if (_subsManager.HasSubscriptionsForEvent(eventName))
      {
        await using var scope = _serviceProvider.CreateAsyncScope();
        var subscriptions = _subsManager.GetHandlersForEvent(eventName);
        foreach (var subscription in subscriptions)
        {
          var handler = scope.ServiceProvider.GetService(subscription.HandlerType);
          if (handler is null) continue;
          var eventType = _subsManager.GetEventTypeByName(eventName)!;
          var integrationEvent = JsonSerializer.Deserialize(message, eventType);
          var concreteType = typeof(IIntegrationEventHandler<>).MakeGenericType(eventType);

          await Task.Yield();
          await (Task)concreteType.GetMethod("Handle")!.Invoke(handler, new object[] { integrationEvent! })!;
        }
      }
      else
      {
        _logger.LogWarning("No subscription for Kafka event: {EventName}", eventName);
      }
    }

    public void Dispose()
    {
      _producer?.Dispose();
      _consumer?.Dispose();
    }

    private void OnBreak(Exception exception, TimeSpan timespan)
    {
      _logger.LogError("Consumer Open (onBreak) - {@exception}", exception);
    }

    private void OnReset()
    {
      _logger.LogWarning("Closed (onReset)");
    }

    private void OnHalfOpen()
    {
      _logger.LogWarning("Half Open (onHalfOpen)");
    }
  }
}