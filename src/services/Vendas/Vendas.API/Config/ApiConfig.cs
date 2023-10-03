﻿using Common.WebAPI.Auth;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.PostgreSql;
using Common.WebAPI.Results;
using Common.WebAPI.Shared.Pipeline;
using Common.WebAPI.Utils;
using Common.WebAPI.WebApi;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Reflection;
using Vendas.Domain.Aggregates;
using Vendas.Infra.Data;
using Vendas.Infra.Repositories;

namespace Vendas.API.Config
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
      services.AddScoped<DbContext, ApplicationDbContext>();
      services.AddScoped<IUnitOfWork, UnitOfWork>();
      services.AddUtils();

      services.AddAuthServices();
      services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly()));
      services.AddScoped<ICompradorRepository, CompradorRepository>();
      services.AddScoped<IVendaRepository, VendaRepository>();
      services.AddScoped(typeof(IPipelineBehavior<,>), typeof(TransactionBehavior<,>));

      services.AddMvc(opt =>
      {
#if DEBUG
        opt.Filters.Add<DelayDebugAttribute>();
#endif
      });

      return services;
    }

    public static IApplicationBuilder UseApiConfiguration(this WebApplication app)
    {
      app.RunMigrations<ApplicationDbContext>();
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