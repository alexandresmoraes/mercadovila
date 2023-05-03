using Common.EventBus.Integrations;

namespace Common.EventBus
{
  public interface IProducer
  {
    Task PublishAsync<TEvent>(string key, TEvent @event, CancellationToken cancellationToken = default) where TEvent : Event;
  }
}