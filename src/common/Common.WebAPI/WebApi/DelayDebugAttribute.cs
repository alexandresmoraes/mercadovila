using Microsoft.AspNetCore.Mvc.Filters;

namespace Common.WebAPI.WebApi
{
#if DEBUG
  public class DelayDebugAttribute : Attribute, IAsyncActionFilter
  {
    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
      var cancellationToken = context.HttpContext.RequestAborted;
      cancellationToken.ThrowIfCancellationRequested();

      await Task.Delay(1000);
      await next();
    }
  }
#endif
}