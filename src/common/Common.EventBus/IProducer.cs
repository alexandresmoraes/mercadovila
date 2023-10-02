using Common.EventBus.Integrations;

namespace Common.EventBus
{
  public interface IProducer
  {
    Task PublishAsync<TIntegrationEvent>(string key, TIntegrationEvent @event, CancellationToken cancellationToken = default) where TIntegrationEvent : IntegrationEvent;
  }
}