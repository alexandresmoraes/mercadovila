using Common.WebAPI.Results;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.Data
{
  public class UnitOfWorkCommitAttribute<TDbContext> : Attribute, IAsyncActionFilter
    where TDbContext : DbContext
  {
    private readonly IUnitOfWork<TDbContext> _uow;
    private readonly ILogger<UnitOfWorkCommitAttribute<TDbContext>> _logger;

    public UnitOfWorkCommitAttribute(IUnitOfWork<TDbContext> uow, ILogger<UnitOfWorkCommitAttribute<TDbContext>> logger)
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
        var objectResult = result.Result as ObjectResult;
        if (objectResult != null && objectResult.Value is Result resultValue)
        {
          if (resultValue.IsValid)
            await _uow.CommitAsync(cancellationToken);
          else
            await _uow.RollbackAsync(cancellationToken);
        }
        else
        {
          await _uow.RollbackAsync(cancellationToken);
        }
      }
      catch (OperationCanceledException)
      {
        await _uow.RollbackAsync(cancellationToken);
        _logger.LogInformation("Cancellation Requested");
      }
    }
  }

  public class UnitOfWorkExceptionAttribute<TDbContext> : Attribute, IAsyncActionFilter
    where TDbContext : DbContext
  {
    private readonly IUnitOfWork<TDbContext> _uow;
    private readonly ILogger<UnitOfWorkExceptionAttribute<TDbContext>> _logger;

    public UnitOfWorkExceptionAttribute(IUnitOfWork<TDbContext> uow, ILogger<UnitOfWorkExceptionAttribute<TDbContext>> logger)
    {
      _uow = uow ?? throw new ArgumentNullException(nameof(uow));
      _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      var result = await next();

      if (result.Exception is not null)
      {
        await _uow.RollbackAsync(cancellationToken);
        _logger.LogInformation("Roolback exception");
      }
    }
  }
}