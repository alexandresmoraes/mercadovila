using Microsoft.AspNetCore.Http;
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

  public class ResultCreatedFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is Result result && result.GetType().IsGenericType && result.IsValid && result is IResultCreated)
        {
          var data = result.GetType().GetProperty(nameof(Result<object>.Data))?.GetValue(result, null);
          context.Result = new ObjectResult(data)
          {
            StatusCode = StatusCodes.Status201Created
          };
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
          context.Result = new NotFoundResult();
        }
      }

      base.OnResultExecuting(context);
    }
  }

  public class ResultUnauthorizedFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is Result result && result is IResultUnauthorized)
        {
          context.Result = new UnauthorizedResult();
        }
      }

      base.OnResultExecuting(context);
    }
  }

  public class ResultForbiddenFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is Result result && result is IResultForbidden)
        {
          context.Result = new ForbidResult();
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
          context.Result = new NoContentResult();
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
          context.Result = new BadRequestObjectResult(result);
        }
      }

      base.OnResultExecuting(context);
    }
  }
}