using Common.EventBus.Integrations;
using Confluent.Kafka;
using Microsoft.Extensions.Logging;
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

    public Producer(ILogger<Producer> logger, EventBusSettings settings)
    {
      _eventBusSettings = settings;
      _logger = logger;

      _producerConfig = new ProducerConfig
      {
        BootstrapServers = _eventBusSettings.BootstrapServer
      };

      _retryPolicy = Policy
        .Handle<Exception>()
        .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)), (exception, retryCount, context) =>
        {
          _logger.LogError("Producer try: {retryCount}, exception: {exception}", retryCount, nameof(exception));
        });
    }

    public async Task PublishAsync<TIntegrationEvent>(string key, TIntegrationEvent @event, CancellationToken cancellationToken = default) where TIntegrationEvent : IntegrationEvent
    {
      using var producer = new ProducerBuilder<string, string>(_producerConfig).Build();
      var serialized = JsonSerializer.Serialize(@event);

      await _retryPolicy.ExecuteAsync(async () =>
      {
        _logger.LogInformation("Producer message: {IntegrationEvent}", nameof(TIntegrationEvent));

        await producer.ProduceAsync(_eventBusSettings.Topic, new Message<string, string>
        {
          Key = key,
          Value = serialized
        }, cancellationToken);
      });

      producer.Flush(cancellationToken);
    }
  }
}