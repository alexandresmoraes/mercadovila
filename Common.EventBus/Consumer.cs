using Common.EventBus.Integrations;
using Confluent.Kafka;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Polly;
using Polly.Retry;
using System.Text.Json;

namespace Common.EventBus
{
  public class Consumer : IConsumer
  {
    private readonly ConsumerConfig _consumerConfig;
    private readonly ILogger<Consumer> _logger;
    private readonly EventBusSettings _eventBusSettings = null!;
    private readonly AsyncRetryPolicy _retryPolicy;

    public Consumer(ILogger<Consumer> logger, IConfiguration configuration)
    {
      var _eventBusSettings = configuration.GetSection(nameof(EventBusSettings)).Get<EventBusSettings>();

      if (_eventBusSettings is null)
        throw new ArgumentNullException(nameof(EventBusSettings));

      _consumerConfig = new ConsumerConfig
      {
        GroupId = _eventBusSettings.Group,
        BootstrapServers = _eventBusSettings.BootstrapServer,
        AutoOffsetReset = AutoOffsetReset.Earliest
      };

      _logger = logger;

      _retryPolicy = Policy
        .Handle<ConsumeException>()
        .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)), (exception, retryCount, context) =>
        {
          _logger.LogError($"Consumer try: {retryCount}, exception: {exception.Message}");
        });
    }

    public Task Consume<TEvent>(Action<TEvent> onEventReceived, CancellationToken cancellationToken = default) where TEvent : Event
    {
      using (var consumer = new ConsumerBuilder<string, string>(_consumerConfig).Build())
      {
        consumer.Subscribe(_eventBusSettings.Topic);

        while (true)
        {
          _retryPolicy.ExecuteAsync(() =>
          {
            var result = consumer.Consume(cancellationToken);

            if (result is not null)
            {
              var @event = JsonSerializer.Deserialize<TEvent>(result.Message.Value);
              onEventReceived(@event!);
            }

            return Task.CompletedTask;
          });
        }
      }
    }
  }
}