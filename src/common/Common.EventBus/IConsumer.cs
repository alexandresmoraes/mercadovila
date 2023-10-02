using Common.EventBus.Integrations;

namespace Common.EventBus
{
  public interface IConsumer
  {
    Task Consume<TIntegrationEvent>(Action<TIntegrationEvent> onEventReceived, CancellationToken cancellationToken = default) where TIntegrationEvent : IntegrationEvent;
  }
}