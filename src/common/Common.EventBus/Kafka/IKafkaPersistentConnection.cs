using Confluent.Kafka;

namespace Common.EventBus.Kafka
{
  public interface IKafkaPersistentConnection : IDisposable
  {
    IProducer<string, string> GetProducer();
    IConsumer<string, string> GetConsumer();
  }
}