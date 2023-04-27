using Auth.API.Data;
using Common.WebAPI.Auth;
using Common.WebAPI.Data;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace Auth.API.Config
{
  public static class ApiConfig
  {
    public static IServiceCollection AddApiConfiguration(this IServiceCollection services, IConfiguration configuration)
    {
      var authSettings = configuration.GetSection(nameof(AuthSettings));
      services.Configure<AuthSettings>(authSettings);
      services.AddResultFilter();
      services.AddDefaultHealthCheck().AddPostgresHealthCheck(configuration);
      services.AddDefaultHealthCheckUI();
      services.AddControllers();
      services.AddEndpointsApiExplorer();
      services.AddOpenApi();
      services.AddAuthServices<IdentityUser, string>();
      services.Configure<ApiBehaviorOptions>(options =>
      {
        options.SuppressModelStateInvalidFilter = false;
      });
      services.AddDbContext<ApplicationDbContext>();
      services.AddScoped<IUnitOfWork<ApplicationDbContext>, UnitOfWork<ApplicationDbContext>>();
      services.AddUnitOfWork<ApplicationDbContext>();

      return services;
    }

    public static IApplicationBuilder UseApiConfiguration(this WebApplication app)
    {
      app.RunMigrations<ApplicationDbContext>();

      if (app.Environment.IsDevelopment())
      {
        app.UseOpenApi();
        app.UseDeveloperExceptionPage();
      }

      app.UseHttpsRedirection();
      app.UseRouting();
      app.UseAuthentication();
      app.UseAuthorization();
      app.MapHealthChecks();
      app.MapHealthChecksUI();
      app.MapControllers();

      return app;
    }
  }
}
