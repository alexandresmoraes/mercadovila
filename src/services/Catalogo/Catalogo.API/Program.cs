using Catalogo.API.Config;
using Catalogo.API.IntegrationEvents.EventHandling;
using Common.EventBus;
using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;
using Common.WebAPI.Logs;
using Serilog;
using System.Reflection;

var appName = Assembly.GetEntryAssembly()!.GetName().Name;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApiConfiguration(builder.Configuration);

builder.Services.AddAuthConfig(builder.Configuration);

builder.Logging.AddSerilog(builder.Configuration);
builder.Services.AddSerilog();





builder.Services.AddTransient<VendaCriadaIntegrationEventHandler>();
builder.Services.AddTransient<VendaCanceladaIntegrationEventHandler>();

builder.Services.AddSingleton<IEventBusSubscriptionsManager, EventBusSubscriptionsManager>();
builder.Services.AddSingleton<IEventBus, KafkaEventBus>(sp =>
{
  var logger = sp.GetRequiredService<ILogger<KafkaEventBus>>();
  var eventBusSettings = sp.GetRequiredService<EventBusSettings>();
  var subManager = sp.GetRequiredService<IEventBusSubscriptionsManager>();

  return new KafkaEventBus(logger, eventBusSettings, sp, subManager);
});

Log.Logger = CreateSerilogLogger(builder.Configuration);

try
{
  Log.Information("Configuring web app ({ApplicationContext})...", appName);
  var app = builder.Build();

  ConfigureEventBus(app);

  app.UseApiConfiguration();

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

void ConfigureEventBus(IApplicationBuilder app)
{
  var eventBus = app.ApplicationServices.GetRequiredService<IEventBus>();

  eventBus.Subscribe<VendaCriadaIntegrationEvent, VendaCriadaIntegrationEventHandler>();
  eventBus.Subscribe<VendaCanceladaIntegrationEvent, VendaCanceladaIntegrationEventHandler>();
}