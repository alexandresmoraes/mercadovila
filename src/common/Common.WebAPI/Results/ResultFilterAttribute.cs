using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Common.WebAPI.Results
{
  public class ResultOkFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is Result result && result.GetType().IsGenericType && result.IsValid)
        {
          var data = result.GetType().GetProperty(nameof(Result<object>.Data))?.GetValue(result, null);
          context.Result = new OkObjectResult(data);
        }
      }

      base.OnResultExecuting(context);
    }
  }

  public class ResultNotFoundFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is Result result && result is IResultNotFound)
        {
          context.Result = new NotFoundObjectResult(new Result(result.Errors));
        }
      }

      base.OnResultExecuting(context);
    }
  }

  public class ResultNoContentFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is Result result && result is IResultNoContent)
        {
          context.Result = new NotFoundObjectResult(new Result(result.Errors));
        }
      }

      base.OnResultExecuting(context);
    }
  }

  public class ResultBadRequestFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is Result result && result.HasError)
        {
          context.Result = new NotFoundObjectResult(new Result(result.Errors));
        }
      }

      base.OnResultExecuting(context);
    }
  }
}