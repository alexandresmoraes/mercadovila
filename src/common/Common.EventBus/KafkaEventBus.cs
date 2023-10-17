using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;
using Common.EventBus.Kafka;
using Common.WebAPI.Utils;
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
    private readonly IKafkaPersistentConnection _consumerBuilder;
    private readonly IKafkaPersistentConnection _producerBuilder;
    private readonly EventBusSettings _eventBusSettings;
    private readonly IServiceProvider _serviceProvider;
    private readonly IEventBusSubscriptionsManager _subsManager;
    private readonly AsyncPolicyWrap _policyWrap;
    private readonly int _retryCount;

    public KafkaEventBus(
      ILogger<KafkaEventBus> logger,
      IKafkaPersistentConnection consumerBuilder,
      IKafkaPersistentConnection producerBuilder,
      EventBusSettings eventBusSettings,
      IServiceProvider serviceProvider,
      IEventBusSubscriptionsManager subsManager,
      int retryCount = 5)
    {
      _logger = logger;
      _consumerBuilder = consumerBuilder;
      _producerBuilder = producerBuilder;
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

      using var producer = _producerBuilder.GetProducer();

      var message = JsonSerializer.Serialize(@event);

      await policy.ExecuteAsync(async () =>
      {
        _logger.LogTrace("Publishing event to Kafka: {EventId}", @event.Id);

        await producer.ProduceAsync(_eventBusSettings.Topic, new Message<string, string>
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

      using var consumer = _consumerBuilder.GetConsumer();

      consumer.Subscribe(_eventBusSettings.Topic);

      Task.Run(async () =>
      {
        while (true)
        {
          try
          {
            var result = consumer.Consume();

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

              consumer.Commit();
            }
          }
          catch (Exception ex)
          {
            _logger.LogWarning(ex, "----- ERROR Processing event \"{@eventName}\"", eventName);
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
          if (handler == null) continue;
          var eventType = _subsManager.GetEventTypeByName(eventName)!;
          var integrationEvent = JsonSerializer.Deserialize(message, eventType, new JsonSerializerOptions() { PropertyNameCaseInsensitive = true });
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
      _producerBuilder?.Dispose();
      _consumerBuilder?.Dispose();
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