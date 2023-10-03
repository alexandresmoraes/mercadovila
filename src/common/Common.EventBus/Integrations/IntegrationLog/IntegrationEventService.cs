using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Data.Common;

namespace Common.EventBus.Integrations.IntegrationLog
{
  public class IntegrationEventService
  {
    private readonly Func<DbConnection, IIntegrationEventLogService> _integrationEventLogServiceFactory;
    private readonly IProducer _producer;
    private readonly DbContext _dbContext;
    private readonly IIntegrationEventLogService _eventLogService;
    private readonly ILogger<IntegrationEventService> _logger;
    private readonly string _appName;
    private readonly string _userId;

    public IntegrationEventService(Func<DbConnection, IIntegrationEventLogService> integrationEventLogServiceFactory, IProducer producer, DbContext dbContext, ILogger<IntegrationEventService> logger, Func<string> appName, Func<string> userId)
    {
      _integrationEventLogServiceFactory = integrationEventLogServiceFactory;
      _producer = producer;
      _dbContext = dbContext;
      _eventLogService = _integrationEventLogServiceFactory(_dbContext.Database.GetDbConnection());
      _logger = logger;
      _appName = appName();
      _userId = userId();
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
          await _producer.PublishAsync(_userId, logEvt.IntegrationEvent);
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
