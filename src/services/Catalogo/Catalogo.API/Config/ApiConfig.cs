using Common.WebAPI.HealthCheck;
using Common.WebAPI.WebApi;

namespace Catalogo.API.Config
{
  public static class ApiConfig
  {
    public static IApplicationBuilder UseApiConfiguration(this WebApplication app)
    {
      app.MapHealthChecks();

      if (app.Environment.IsDevelopment())
      {
        app.UseOpenApi();
        app.MapHealthChecksUI();
      }

      app.UseMiddleware<ErrorHandlerMiddleware>();
      app.UseRouting();
      app.UseAuthentication();
      app.UseAuthorization();
      app.MapControllers();

      return app;
    }
  }
}
