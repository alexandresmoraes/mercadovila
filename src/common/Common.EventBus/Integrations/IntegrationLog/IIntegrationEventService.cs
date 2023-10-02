using Microsoft.EntityFrameworkCore.Storage;

namespace Common.EventBus.Integrations
{
  public interface IIntegrationEventService
  {
    Task<IEnumerable<IntegrationEventLog>> RetrieveEventLogsPendingToPublishAsync(Guid transactionId);
    Task SaveEventAsync(IntegrationEvent @event, IDbContextTransaction transaction);
    Task MarkEventAsPublishedAsync(Guid eventId);
    Task MarkEventAsInProgressAsync(Guid eventId);
    Task MarkEventAsFailedAsync(Guid eventId);
  }
}
