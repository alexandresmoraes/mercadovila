using Common.EventBus.Integrations.IntegrationEvents;

namespace Common.EventBus.Abstractions
{
    public interface IConsumer
    {
        Task Consume<TIntegrationEvent>(Action<TIntegrationEvent> onEventReceived, CancellationToken cancellationToken = default) where TIntegrationEvent : IntegrationEvent;
    }
}