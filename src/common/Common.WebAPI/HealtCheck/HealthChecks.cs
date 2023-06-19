using HealthChecks.UI.Client;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace Common.WebAPI.HealthCheck
{
  public static class HealthChecks
  {
    public static IHealthChecksBuilder AddDefaultHealthCheck(this IServiceCollection services)
    {
      return services
          .AddHealthChecks()
          .AddCheck("api", () => HealthCheckResult.Healthy(), tags: new[] { "api" });
    }

    public static IServiceCollection AddDefaultHealthCheckUI(this IServiceCollection services)
    {
      services.AddHealthChecksUI(opt =>
      {
        opt.SetEvaluationTimeInSeconds(10);
        opt.MaximumHistoryEntriesPerEndpoint(60);
        opt.SetApiMaxActiveRequests(1);
      }).AddInMemoryStorage();

      return services;
    }

    public static IApplicationBuilder MapHealthChecks(this IApplicationBuilder app)
    {
      app.UseHealthChecks("/healthz", new HealthCheckOptions
      {
        Predicate = _ => true,
        ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
      });

      return app;
    }

    public static IApplicationBuilder MapHealthChecksUI(this IApplicationBuilder app)
    {
      app.UseHealthChecksUI(options =>
      {
        options.UIPath = "/health-ui";
        options.ApiPath = "/health-ui-api";
      });

      return app;
    }
  }
}