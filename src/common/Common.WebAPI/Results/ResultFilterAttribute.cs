using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Common.WebAPI.Results
{
  public class ResultFilterAttribute : Microsoft.AspNetCore.Mvc.Filters.ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is Result result)
        {
          if (result is IResultNotFound)
          {
            context.Result = new NotFoundObjectResult(new Result(result.Errors));
          }
          else if (result is IResultNoContent)
          {
            context.Result = new NoContentResult();
          }
          else if (result.HasError)
          {
            context.Result = new BadRequestObjectResult(new Result(result.Errors));
          }
          else if (result.GetType().IsGenericType)
          {
            var data = result.GetType().GetProperty(nameof(Result<object>.Data))?.GetValue(result, null);
            context.Result = new OkObjectResult(data);
          }
        }
      }

      base.OnResultExecuting(context);
    }
  }
}