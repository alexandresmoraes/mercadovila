using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Data.Common;

namespace Common.EventBus.Integrations.IntegrationLog
{
  public class IntegrationEventService : IIntegrationEventService
  {
    private readonly Func<DbConnection, IIntegrationEventLogService> _integrationEventLogServiceFactory;
    private readonly IEventBus _eventBus;
    private readonly DbContext _dbContext;
    private readonly IIntegrationEventLogService _eventLogService;
    private readonly ILogger<IntegrationEventService> _logger;
    private readonly string _appName;

    public IntegrationEventService(Func<DbConnection, IIntegrationEventLogService> integrationEventLogServiceFactory, IEventBus eventBus, DbContext dbContext, ILogger<IntegrationEventService> logger, string appName)
    {
      _integrationEventLogServiceFactory = integrationEventLogServiceFactory;
      _eventBus = eventBus;
      _dbContext = dbContext;
      _eventLogService = _integrationEventLogServiceFactory(_dbContext.Database.GetDbConnection());
      _logger = logger;
      _appName = appName;
    }

    public async Task PublishEventsThroughEventBusAsync(Guid transactionId)
    {
      var pendingLogEvents = await _eventLogService.RetrieveEventLogsPendingToPublishAsync(transactionId);

      foreach (var logEvt in pendingLogEvents)
      {
        _logger.LogInformation("----- Publishing integration event: {IntegrationEventId} from {AppName} - ({@IntegrationEvent})", logEvt.EventId, _appName, logEvt.IntegrationEvent);

        try
        {
          await _eventLogService.MarkEventAsInProgressAsync(logEvt.EventId);
          await _eventBus.PublishAsync(logEvt.IntegrationEvent);
          await _eventLogService.MarkEventAsPublishedAsync(logEvt.EventId);
        }
        catch (Exception ex)
        {
          _logger.LogError(ex, "ERROR publishing integration event: {IntegrationEventId} from {AppName}", logEvt.EventId, _appName);

          await _eventLogService.MarkEventAsFailedAsync(logEvt.EventId);
        }
      }
    }

    public async Task AddAndSaveEventAsync(IntegrationEvent evt)
    {
      _logger.LogInformation("----- Enqueuing integration event {IntegrationEventId} to repository ({@IntegrationEvent})", evt.Id, evt);

      await _eventLogService.SaveEventAsync(evt, _dbContext.Database.CurrentTransaction!);
    }
  }
}
