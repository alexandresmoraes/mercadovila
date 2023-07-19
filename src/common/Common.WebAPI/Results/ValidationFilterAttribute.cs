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
        var errors = new List<ErrorResult>();
        foreach (var modelStateKey in context.ModelState.Keys)
        {
          var value = context.ModelState[modelStateKey];
          foreach (var error in value?.Errors!)
          {
            errors.Add(new ErrorResult(null, modelStateKey, error.ErrorMessage));
          }
        }

        context.Result = new BadRequestObjectResult(new Result(errors));
      }
      else
      {
        await next();
      }
    }
  }
}
