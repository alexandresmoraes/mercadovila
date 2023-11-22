using Common.EventBus.Integrations.IntegrationEvents;

namespace Common.EventBus.Integrations.IntegrationLog
{
  public interface IIntegrationEventService
  {
    Task PublishEventsThroughEventBusAsync(Guid transactionId);
    Task AddAndSaveEventAsync(IntegrationEvent evt);
  }
}
