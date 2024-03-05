using Common.WebAPI.WebApi;
using Compras.Infra.Data;
using Microsoft.EntityFrameworkCore;

namespace Compras.API.Config
{
  public static class ApiConfig
  {
    public static IServiceCollection AddApiConfiguration(this IServiceCollection services, IConfiguration configuration)
    {
      services.AddDbContext<ApplicationDbContext>();
      services.AddScoped<DbContext>(_ => _.GetRequiredService<ApplicationDbContext>());

      return services;
    }

    public static IApplicationBuilder UseApiConfiguration(this WebApplication app)
    {
      //app.RunMigrations<ApplicationDbContext>();
      //app.MapHealthChecks();

      if (app.Environment.IsDevelopment())
      {
        //app.UseOpenApi();
        //app.MapHealthChecksUI();
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
