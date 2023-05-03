using Common.EventBus.Integrations;
using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Polly;
using Polly.Retry;
using System.Text.Json;

namespace Common.EventBus
{
  public class Producer : IProducer
  {
    private readonly ProducerConfig _producerConfig;
    private readonly AsyncRetryPolicy _retryPolicy;
    private readonly EventBusSettings _eventBusSettings = null!;
    private readonly ILogger<Producer> _logger;

    public Producer(ILogger<Producer> logger, IOptions<EventBusSettings> settings)
    {
      _eventBusSettings = settings.Value;
      _logger = logger;

      _producerConfig = new ProducerConfig
      {
        BootstrapServers = _eventBusSettings.BootstrapServer
      };

      _retryPolicy = Policy
        .Handle<ProduceException<string, string>>()
        .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)), (exception, retryCount, context) =>
        {
          _logger.LogError($"Producer try: {retryCount}, exception: {exception.Message}");
        });
    }

    public async Task PublishAsync<TEvent>(string key, TEvent @event, CancellationToken cancellationToken = default) where TEvent : Event
    {
      using (var producer = new ProducerBuilder<string, string>(_producerConfig).Build())
      {
        var serialized = JsonSerializer.Serialize(@event);

        await _retryPolicy.ExecuteAsync(async () =>
        {
          _logger.LogInformation($"Producer message: {serialized}");

          await producer.ProduceAsync(_eventBusSettings.Topic, new Message<string, string>
          {
            Key = key,
            Value = serialized
          }, cancellationToken);
        });

        producer.Flush();
      }
    }
  }
}