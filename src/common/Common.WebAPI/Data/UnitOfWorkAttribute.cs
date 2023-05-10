using Common.WebAPI.Results;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.Data
{
  public class UnitOfWorkCommitAttribute : Attribute, IAsyncActionFilter
  {
    private readonly IUnitOfWork _uow;
    private readonly ILogger<UnitOfWorkCommitAttribute> _logger;

    public UnitOfWorkCommitAttribute(IUnitOfWork uow, ILogger<UnitOfWorkCommitAttribute> logger)
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