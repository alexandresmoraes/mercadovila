using Common.WebAPI.PostgreSql;
using Common.WebAPI.Utils;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.Shared.Pipeline
{
  public class TransactionBehavior<TRequest, TResponse, TDbContext> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
    where TDbContext : DbContext
  {
    private readonly ILogger<TransactionBehavior<TRequest, TResponse, TDbContext>> _logger;
    private readonly IUnitOfWork _uow;
    private readonly TDbContext _context;

    public TransactionBehavior(
      ILogger<TransactionBehavior<TRequest, TResponse, TDbContext>> logger,
      IUnitOfWork uow,
      TDbContext context)
    {
      _logger = logger;
      _uow = uow;
      _context = context;
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

          await _uow.BeginTransactionAsync();
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
          //await _orderingIntegrationEventService.PublishEventsThroughEventBusAsync(transactionId);
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