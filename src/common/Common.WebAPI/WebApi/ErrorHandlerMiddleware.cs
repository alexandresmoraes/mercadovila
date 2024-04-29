using Common.WebAPI.Results;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.Tokens;
using System.Net;
using System.Text.Json;

namespace Common.WebAPI.WebApi
{
  public class ErrorHandlerMiddleware
  {
    private readonly RequestDelegate _next;

    public ErrorHandlerMiddleware(RequestDelegate next)
    {
      _next = next;
    }

    public async Task Invoke(HttpContext context)
    {
      try
      {
        await _next(context);
      }
      catch (Exception error)
      {
        var response = context.Response;
        response.ContentType = "application/json";

        switch (error)
        {
          case SecurityTokenException e:
            response.StatusCode = (int)HttpStatusCode.Unauthorized;
            break;
          case TaskCanceledException e:
            response.StatusCode = 499;
            break;
          case OperationCanceledException e:
            response.StatusCode = 499;
            break;
          default:
            response.StatusCode = (int)HttpStatusCode.InternalServerError;
            break;
        }

        var result = JsonSerializer.Serialize(Result.Fail(error.Message));
        await response.WriteAsync(result);
      }
    }
  }
}