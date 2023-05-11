using Auth.API.Data;
using Auth.API.Data.Repositories;
using Common.WebAPI.Auth;
using Common.WebAPI.Data;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.Results;
using Common.WebAPI.WebApi;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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
      services.AddScoped<IUserRepository, UserRepository>();
      services.Configure<ApiBehaviorOptions>(options =>
      {
        options.SuppressMapClientErrors = true;
        options.SuppressModelStateInvalidFilter = true;
      });
      services.AddDbContext<ApplicationDbContext>();
      services.AddScoped<DbContext, ApplicationDbContext>();
      services.AddScoped<IUnitOfWork, UnitOfWork>();
      services.AddUnitOfWork();

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
      else
      {
        app.UseHttpsRedirection();
      }

      app.UseMiddleware<ErrorHandlerMiddleware>();
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
