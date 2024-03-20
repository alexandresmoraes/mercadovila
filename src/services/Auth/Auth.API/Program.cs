using Auth.API.Config;
using Auth.API.Data;
using Common.EventBus.Integrations;
using Common.WebAPI.Logs;
using Common.WebAPI.PostgreSql;
using Serilog;
using System.Reflection;

var appName = Assembly.GetEntryAssembly()!.GetName().Name;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApiConfiguration(builder.Configuration);
builder.Services.AddAuthConfig(builder.Configuration);

builder.Logging.AddSerilog(builder.Configuration);
builder.Services.AddSerilog();


builder.Services.AddEventBusConfig(builder.Configuration, appName!);


Log.Logger = CreateSerilogLogger(builder.Configuration);

try
{
  Log.Information("Configuring web app ({ApplicationContext})...", appName);
  var app = builder.Build();

  app.UseApiConfiguration();

  Log.Information("Applying migrations ({ApplicationContext})...", appName);

  app.MigrateDbContext<ApplicationDbContext>((_, __) => { })
  .MigrateDbContext<IntegrationEventContext>((_, __) => { });

  Log.Information("Starting web app ({ApplicationContext})...", appName);
  app.Run();

  return 0;
}
catch (Exception ex)
{
  Log.Fatal(ex, "Program terminated unexpectedly ({ApplicationContext})!", appName);
  return 1;
}
finally
{
  Log.CloseAndFlush();
}

Serilog.ILogger CreateSerilogLogger(IConfiguration configuration)
{
  return new LoggerConfiguration()
        .ReadFrom.Configuration(configuration)
        .CreateLogger();
}
