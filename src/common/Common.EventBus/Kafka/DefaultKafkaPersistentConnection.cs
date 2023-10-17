using Confluent.Kafka;
using Microsoft.Extensions.Logging;

namespace Common.EventBus.Kafka
{
  public class DefaultKafkaPersistentConnection : IKafkaPersistentConnection, IDisposable
  {
    private static object _syncRoot = new object();
    private readonly ILogger<IKafkaPersistentConnection> _logger;
    private readonly ConsumerBuilder<string, string>? _consumerBuilder;
    private readonly ProducerBuilder<string, string>? _producerBuilder;
    private readonly List<IConsumer<string, string>>? _consumers;
    private IProducer<string, string>? _producer;
    private bool _disposed;

    public IProducer<string, string> GetProducer()
    {
      if (_producer == null)
      {
        lock (_syncRoot)
        {
          if (_producer == null)
          {
            _producer = _producerBuilder?.Build()!;
          }
        }
      }

      return _producer!;
    }

    public IConsumer<string, string> GetConsumer()
    {
      var consumer = _consumerBuilder?.Build();
      _consumers!.Add(consumer!);
      return consumer!;
    }

    public DefaultKafkaPersistentConnection(ILogger<IKafkaPersistentConnection> logger,
      ProducerConfig producerConfig)
    {
      _logger = logger ?? throw new ArgumentNullException(nameof(logger));
      _producerBuilder = new ProducerBuilder<string, string>(producerConfig);
    }

    public DefaultKafkaPersistentConnection(ILogger<IKafkaPersistentConnection> logger,
        ConsumerConfig consumerConfig)
    {
      _logger = logger ?? throw new ArgumentNullException(nameof(logger));
      _consumers = new List<IConsumer<string, string>>();
      _consumerBuilder = new ConsumerBuilder<string, string>(consumerConfig);
    }

    public void Dispose()
    {
      if (_disposed)
      {
        return;
      }
      try
      {
        if (_consumers != null)
        {
          _consumers.ForEach(consumer =>
          {
            consumer.Dispose();
          });
        }

        if (_producer != null)
        {

          _producer.Dispose();
        }
      }
      catch (IOException ex)
      {
        _logger.LogCritical(ex.ToString());
      }
      finally
      {
        _disposed = true;
      }
    }
  }
}