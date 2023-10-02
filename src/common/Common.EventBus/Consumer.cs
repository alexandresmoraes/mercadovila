using Common.EventBus.Integrations;
using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Polly;
using Polly.Wrap;
using System.Text.Json;

namespace Common.EventBus
{
  public class Consumer : IConsumer
  {
    private readonly ConsumerConfig _consumerConfig;
    private readonly ILogger<Consumer> _logger;
    private readonly EventBusSettings _eventBusSettings = null!;
    private readonly AsyncPolicyWrap _policyWrap;

    public Consumer(ILogger<Consumer> logger, IOptions<EventBusSettings> settings)
    {
      _logger = logger;
      _eventBusSettings = settings.Value;

      _consumerConfig = new ConsumerConfig
      {
        GroupId = _eventBusSettings.Group,
        BootstrapServers = _eventBusSettings.BootstrapServer,
        AutoOffsetReset = AutoOffsetReset.Earliest
      };

      var retryPolicy = Policy
        .Handle<ConsumeException>()
        .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)), (exception, retryCount, context) =>
        {
          _logger.LogError($"Consumer try: {retryCount}, exception: {exception.Message}");
        });

      var circuitBreakerPolicy = Policy
        .Handle<Exception>()
        .CircuitBreakerAsync(3, TimeSpan.FromMinutes(3),
        onBreak: (_, _) => _logger.LogWarning("Consumer Open (onBreak)"),
        onReset: () => _logger.LogWarning("Closed (onReset)"),
        onHalfOpen: () => _logger.LogWarning("Half Open (onHalfOpen)"));

      _policyWrap = Policy.WrapAsync(retryPolicy, circuitBreakerPolicy);
    }

    public Task Consume<TIntegrationEvent>(Action<TIntegrationEvent> onEventReceived, CancellationToken cancellationToken = default) where TIntegrationEvent : IntegrationEvent
    {
      using (var consumer = new ConsumerBuilder<string, string>(_consumerConfig).Build())
      {
        consumer.Subscribe(_eventBusSettings.Topic);

        while (true)
        {
          _policyWrap.ExecuteAsync(() =>
          {
            var result = consumer.Consume(cancellationToken);

            if (result is not null)
            {
              _logger.LogInformation($"Consumer event started \n"
                   + $"partition: {result.Partition} \n"
                   + $"offset: {result.Offset} \n"
                   + $"timestamp: {result.Message.Timestamp.UtcDateTime}");

              var @event = JsonSerializer.Deserialize<TIntegrationEvent>(result.Message.Value);
              var integrationEvent = @event! as IntegrationEvent;

              _logger.LogInformation($"Consumer eventId: {integrationEvent!.Id} - ({@event})");

              onEventReceived(@event!);
            }

            return Task.CompletedTask;
          });
        }
      }
    }
  }
}