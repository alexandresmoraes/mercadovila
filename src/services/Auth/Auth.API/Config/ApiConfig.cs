using Auth.API.Data;
using Common.WebAPI.Auth;
using Common.WebAPI.Data;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Identity;

namespace Auth.API.Config
{
  public static class ApiConfig
  {
    public static IServiceCollection AddApiConfiguration(this IServiceCollection services, IConfiguration configuration)
    {
      services.AddResultFilter();
      services.AddDefaultHealthCheck().AddPostgresHealthCheck(configuration);
      services.AddDefaultHealthCheckUI();
      services.AddControllers();
      services.AddEndpointsApiExplorer();
      services.AddSwaggerGen();
      services.AddDataProtection();
      services.AddAuthServices<IdentityUser, string>();

      services.AddDbContext<ApplicationDbContext>();

      return services;
    }

    public static IApplicationBuilder UseApiConfiguration(this WebApplication app)
    {
      app.ApplyMigrations<ApplicationDbContext>();

      if (app.Environment.IsDevelopment())
      {
        app.UseSwagger();
        app.UseSwaggerUI(options =>
        {
          options.DefaultModelsExpandDepth(-1);
        });
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
