using Common.EventBus;
using Common.WebAPI.Auth;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.PostgreSql;
using Common.WebAPI.Results;
using Common.WebAPI.Shared.Pipeline;
using Common.WebAPI.Utils;
using Common.WebAPI.WebApi;
using Compras.API.Application.Validators;
using Compras.Infra.Data;
using FluentValidation;
using MediatR;
using MicroElements.Swashbuckle.FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace Compras.API.Config
{
  public static class ApiConfig
  {
    public static IServiceCollection AddApiConfiguration(this IServiceCollection services, IConfiguration configuration)
    {
      bool isDevelopment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development";

      var authSettings = configuration.GetSection(nameof(AuthSettings));
      services.Configure<AuthSettings>(authSettings);
      services.AddResultFilter();
      services.AddDefaultHealthCheck().AddPostgresHealthCheck(configuration);
      if (isDevelopment) services.AddDefaultHealthCheckUI();
      services.AddControllers().AddJsonOptions(options =>
      {
        options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
      });
      services.AddEndpointsApiExplorer();
      services.AddOpenApi();
      services.AddAuthServices();
      services.Configure<ApiBehaviorOptions>(options =>
      {
        options.SuppressMapClientErrors = true;
        options.SuppressModelStateInvalidFilter = true;
      });
      services.AddDbContext<ApplicationDbContext>();
      services.AddScoped<DbContext>(_ => _.GetRequiredService<ApplicationDbContext>());
      services.AddScoped<IUnitOfWork, UnitOfWork>();
      services.AddUtils();

      services.AddAuthServices();
      services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly()));

      services.AddScoped(typeof(IPipelineBehavior<,>), typeof(LoggingBehavior<,>));
      services.AddScoped(typeof(IPipelineBehavior<,>), typeof(ValidatorBehavior<,>));
      services.AddScoped(typeof(IPipelineBehavior<,>), typeof(TransactionBehavior<,>));
      services.AddScoped(typeof(IPipelineBehavior<,>), typeof(DispatchDomainEventsPipeline<,>));

      services.AddSingleton(configuration.BindSettings<EventBusSettings>(nameof(EventBusSettings)));

      services.AddMvc(opt =>
      {
#if DEBUG
        opt.Filters.Add<DelayDebugAttribute>();
#endif
      });

      services.AddValidatorsFromAssemblyContaining<CriarCompraCommandValidator>(includeInternalTypes: true);
      services.AddFluentValidationRulesToSwagger();

      return services;
    }

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
