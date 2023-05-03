using Common.EventBus.Integrations;

namespace Common.EventBus
{
  public interface IConsumer
  {
    Task Consume<TEvent>(Action<TEvent> onEventReceived, CancellationToken cancellationToken = default) where TEvent : Event;
  }
}