using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Common.WebAPI.Results
{
  public class ValidationFilterAttribute : IAsyncActionFilter
  {
    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
      if (!context.ModelState.IsValid)
      {
        var errors = context.ModelState.Values
          .SelectMany(e => e.Errors)
          .Select(e => new ErrorResult(e.ErrorMessage)).ToArray();

        context.Result = new NotFoundObjectResult(new Result(errors));
      }
      else
      {
        await next();
      }
    }
  }
}
