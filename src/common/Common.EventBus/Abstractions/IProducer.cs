using Common.EventBus.Integrations.IntegrationEvents;

namespace Common.EventBus.Abstractions
{
    public interface IProducer
    {
        Task PublishAsync<TIntegrationEvent>(string key, TIntegrationEvent @event, CancellationToken cancellationToken = default) where TIntegrationEvent : IntegrationEvent;
    }
}