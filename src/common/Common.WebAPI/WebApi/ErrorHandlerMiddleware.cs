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

        response.StatusCode = error switch
        {
          SecurityTokenException => (int)HttpStatusCode.Unauthorized,
          TaskCanceledException => 499,
          OperationCanceledException => 499,
          _ => (int)HttpStatusCode.InternalServerError,
        };

        var result = JsonSerializer.Serialize(Result.Fail(error.Message));
        await response.WriteAsync(result);
      }
    }
  }
}