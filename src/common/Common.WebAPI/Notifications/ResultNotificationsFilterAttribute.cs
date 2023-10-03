using Common.WebAPI.Results;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Common.WebAPI.Notifications
{
  public class ResultOkNotificationsFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is ResultNotifications result && result.GetType().IsGenericType && result.IsValid)
        {
          var data = result.GetType().GetProperty(nameof(Result<object>.Data))?.GetValue(result, null);
          context.Result = new OkObjectResult(data);
        }
      }

      base.OnResultExecuting(context);
    }
  }

  public class ResultBadRequestNotificationsFilterAttribute : ResultFilterAttribute
  {
    public override void OnResultExecuting(ResultExecutingContext context)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      if (context.Result is ObjectResult objectResult)
      {
        if (objectResult.Value is ResultNotifications result && result.HasErrors)
        {
          context.Result = new BadRequestObjectResult(result);
        }
      }

      base.OnResultExecuting(context);
    }
  }
}