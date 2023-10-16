using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;

namespace Common.EventBus
{
  public class KafkaEventBus : IEventBus, IDisposable
  {
    public void Publish(IntegrationEvent @event)
    {
      throw new NotImplementedException();
    }

    public void Subscribe<T, TH>()
      where T : IntegrationEvent
      where TH : IIntegrationEventHandler<T>
    {
      throw new NotImplementedException();
    }

    public void Unsubscribe<T, TH>()
      where T : IntegrationEvent
      where TH : IIntegrationEventHandler<T>
    {
      throw new NotImplementedException();
    }

    public void Dispose()
    {
      throw new NotImplementedException();
    }
  }
}