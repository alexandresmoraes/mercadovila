using Common.EventBus.Integrations.IntegrationEvents;
using Microsoft.EntityFrameworkCore.Storage;

namespace Common.EventBus.Integrations
{
  public interface IIntegrationEventLogService
  {
    Task<IEnumerable<IntegrationEventLog>> RetrieveEventLogsPendingToPublishAsync(Guid transactionId);
    Task SaveEventAsync(IntegrationEvent @event, IDbContextTransaction transaction);
    Task MarkEventAsPublishedAsync(string eventId);
    Task MarkEventAsInProgressAsync(string eventId);
    Task MarkEventAsFailedAsync(string eventId);
  }
}
