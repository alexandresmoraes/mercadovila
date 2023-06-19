using Common.WebAPI.Results;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.PostgreSql
{
  public class UnitOfWorkPostgresAttribute : Attribute, IAsyncActionFilter
  {
    private readonly IUnitOfWork _uow;
    private readonly ILogger<UnitOfWorkPostgresAttribute> _logger;

    public UnitOfWorkPostgresAttribute(IUnitOfWork uow, ILogger<UnitOfWorkPostgresAttribute> logger)
    {
      _uow = uow ?? throw new ArgumentNullException(nameof(uow));
      _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      await _uow.BeginTransactionAsync(cancellationToken);

      var result = await next();

      if (result.Exception is not null)
        return;

      try
      {
        if (_uow.IsActive)
        {
          if (result.Result is ObjectResult objectResult
            && objectResult.Value is Result resultValue
            && resultValue.IsValid)
          {
            await _uow.CommitAsync(cancellationToken);
            _logger.LogInformation("commited.");
          }
          else
          {
            await _uow.RollbackAsync(cancellationToken);
            _logger.LogInformation("rollbacked.");
          }
        }
      }
      catch (OperationCanceledException)
      {
        await _uow.RollbackAsync(cancellationToken);
        _logger.LogInformation("Cancellation Requested");
      }
    }
  }

  public class UnitOfWorkExceptionAttribute : Attribute, IAsyncActionFilter
  {
    private readonly IUnitOfWork _uow;
    private readonly ILogger<UnitOfWorkExceptionAttribute> _logger;

    public UnitOfWorkExceptionAttribute(IUnitOfWork uow, ILogger<UnitOfWorkExceptionAttribute> logger)
    {
      _uow = uow ?? throw new ArgumentNullException(nameof(uow));
      _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      var result = await next();

      if (result.Exception is not null && _uow.IsActive)
      {
        await _uow.RollbackAsync(cancellationToken);
        _logger.LogInformation("Roolback exception");
      }
    }
  }
}