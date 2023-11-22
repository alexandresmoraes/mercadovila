using Common.EventBus.Integrations.IntegrationLog;
using Common.WebAPI.PostgreSql;
using Common.WebAPI.Utils;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.Shared.Pipeline
{
  public class TransactionBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
  {
    private readonly ILogger<TransactionBehavior<TRequest, TResponse>> _logger;
    private readonly IUnitOfWork _uow;
    private readonly DbContext _context;
    private readonly IIntegrationEventService _integrationEventService;

    public TransactionBehavior(ILogger<TransactionBehavior<TRequest, TResponse>> logger, IUnitOfWork uow, DbContext context, IIntegrationEventService integrationEventService)
    {
      _logger = logger;
      _uow = uow;
      _context = context;
      _integrationEventService = integrationEventService;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
      var response = default(TResponse);
      var typeName = request.GetGenericTypeName();

      try
      {
        if (_uow.HasActiveTransaction)
        {
          return await next();
        }

        var strategy = _context.Database.CreateExecutionStrategy();

        await strategy.ExecuteAsync(async () =>
        {
          Guid transactionId;

          await _uow.BeginTransactionAsync(cancellationToken);
          using var transaction = _uow.GetTransaction<IDbContextTransaction>();
          using (_logger.BeginScope(new List<KeyValuePair<string, object>> { new("TransactionContext", transaction.TransactionId) }))
          {
            _logger.LogInformation("Begin transaction {TransactionId} for {CommandName} ({@Command})", transaction.TransactionId, typeName, request);

            response = await next();

            _logger.LogInformation("Commit transaction {TransactionId} for {CommandName}", transaction.TransactionId, typeName);

            await _uow.CommitAsync(cancellationToken);

            transactionId = transaction.TransactionId;
          }

          // TODO
          await _integrationEventService.PublishEventsThroughEventBusAsync(transactionId);
        });

        return response!;
      }
      catch (Exception ex)
      {
        _logger.LogError(ex, "Error Handling transaction for {CommandName} ({@Command})", typeName, request);

        throw;
      }
    }
  }
}