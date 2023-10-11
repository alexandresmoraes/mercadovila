using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using System.Data.Common;
using System.Reflection;

namespace Common.EventBus.Integrations.IntegrationLog
{
  public class IntegrationEventLogService : IIntegrationEventLogService, IDisposable
  {
    private readonly IntegrationEventContext _integrationEventContext;
    private readonly DbConnection _dbConnection;
    private readonly List<Type> _eventTypes;
    private volatile bool _disposedValue;

    public IntegrationEventLogService(DbConnection dbConnection)
    {
      _dbConnection = dbConnection ?? throw new ArgumentNullException(nameof(dbConnection));
      _integrationEventContext = new IntegrationEventContext(
          new DbContextOptionsBuilder<IntegrationEventContext>()
              .UseNpgsql(_dbConnection)
              .Options);

      _eventTypes = Assembly.Load(Assembly.GetEntryAssembly()!.FullName!)
          .GetTypes()
          .Where(t => t.Name.EndsWith(nameof(IntegrationEvent)))
          .ToList();
    }

    public Task MarkEventAsFailedAsync(Guid eventId)
    {
      return UpdateEventStatus(eventId, EnumEventState.PublishedFailed);
    }

    public Task MarkEventAsInProgressAsync(Guid eventId)
    {
      return UpdateEventStatus(eventId, EnumEventState.InProgress);
    }

    public Task MarkEventAsPublishedAsync(Guid eventId)
    {
      return UpdateEventStatus(eventId, EnumEventState.Published);
    }

    private Task UpdateEventStatus(Guid eventId, EnumEventState status)
    {
      var eventLogEntry = _integrationEventContext.IntegrationEventLogs.Single(ie => ie.EventId == eventId);
      eventLogEntry.State = status;

      if (status == EnumEventState.InProgress)
        eventLogEntry.TimesSent++;

      _integrationEventContext.IntegrationEventLogs.Update(eventLogEntry);

      return _integrationEventContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<IntegrationEventLog>> RetrieveEventLogsPendingToPublishAsync(Guid transactionId)
    {
      var tid = transactionId.ToString();

      var result = await _integrationEventContext.IntegrationEventLogs
          .Where(e => e.TransactionId == tid && e.State == EnumEventState.NotPublished).ToListAsync();

      if (result.Any())
      {
        return result.OrderBy(o => o.CreationTime)
            .Select(e => e.DeserializeJsonContent(_eventTypes.Find(t => t.Name == e.EventTypeShortName)!));
      }

      return Enumerable.Empty<IntegrationEventLog>();
    }

    public Task SaveEventAsync(IntegrationEvent @event, IDbContextTransaction transaction)
    {
      if (transaction == null) throw new ArgumentNullException(nameof(transaction));

      var eventLogEntry = new IntegrationEventLog(@event, transaction.TransactionId);

      _integrationEventContext.Database.UseTransaction(transaction.GetDbTransaction());
      _integrationEventContext.IntegrationEventLogs.Add(eventLogEntry);

      return _integrationEventContext.SaveChangesAsync();
    }

    protected virtual void Dispose(bool disposing)
    {
      if (!_disposedValue)
      {
        if (disposing)
        {
          _integrationEventContext?.Dispose();
        }

        _disposedValue = true;
      }
    }

    public void Dispose()
    {
      Dispose(disposing: true);
      GC.SuppressFinalize(this);
    }
  }
}