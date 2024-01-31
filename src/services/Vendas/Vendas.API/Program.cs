using Common.EventBus;
using Common.EventBus.Abstractions;
using Common.EventBus.Integrations;
using Common.EventBus.Integrations.IntegrationLog;
using Common.Grpc;
using Common.WebAPI.Logs;
using Common.WebAPI.PostgreSql;
using GrpcVendas;
using Microsoft.EntityFrameworkCore;
using Serilog;
using System.Data;
using System.Data.Common;
using System.Reflection;
using Vendas.API.Application.Queries;
using Vendas.API.Config;
using Vendas.Infra.Data;

var appName = Assembly.GetEntryAssembly()!.GetName().Name;

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApiConfiguration(builder.Configuration);

builder.Services.AddAuthConfig(builder.Configuration);

builder.Logging.AddSerilog(builder.Configuration);
builder.Services.AddSerilog();

builder.Services.AddTransient<GrpcExceptionInterceptor>();

builder.Services.AddGrpcClient<Carrinho.CarrinhoClient>((services, options) =>
{
  var grpcUrl = builder.Configuration.GetSection("CatalogoUrlGrpc").Value;
  options.Address = new Uri(grpcUrl);
}).AddInterceptor<GrpcExceptionInterceptor>();

builder.Services.AddScoped<IDbConnection>(sp => sp.GetService<DbContext>()!.Database.GetDbConnection());
builder.Services.AddScoped<IVendasQueries, VendasQueries>();
builder.Services.AddScoped<IPagamentosQueries, PagamentoQueries>();












builder.Services.AddDbContext<IntegrationEventContext>(options =>
{
  options.UseNpgsql(builder.Configuration.GetConnectionString("Default"),
    opt =>
    {
      opt.MigrationsAssembly(Assembly.GetAssembly(typeof(ApplicationDbContext))!.GetName().Name);
      opt.EnableRetryOnFailure(maxRetryCount: 15, maxRetryDelay: TimeSpan.FromSeconds(30), errorCodesToAdd: null);
    });
});

builder.Services.AddSingleton<IEventBusSubscriptionsManager, EventBusSubscriptionsManager>();
builder.Services.AddSingleton<IEventBus, KafkaEventBus>(sp =>
{
  var logger = sp.GetRequiredService<ILogger<KafkaEventBus>>();
  var eventBusSettings = sp.GetRequiredService<EventBusSettings>();
  var subManager = sp.GetRequiredService<IEventBusSubscriptionsManager>();

  return new KafkaEventBus(logger, eventBusSettings, sp, subManager);
});
builder.Services.AddScoped<Func<DbConnection, IIntegrationEventLogService>>(sp => (DbConnection c) => new IntegrationEventLogService(c));
builder.Services.AddScoped<IIntegrationEventService, IntegrationEventService>((sp) =>
{
  var integrationEventLogServiceFactory = (DbConnection connection) =>
  {
    return new IntegrationEventLogService(connection);
  };
  var eventBus = sp.GetRequiredService<IEventBus>();
  var dbContext = sp.GetRequiredService<DbContext>();
  var logger = sp.GetRequiredService<ILogger<IntegrationEventService>>();

  return new IntegrationEventService(integrationEventLogServiceFactory, eventBus, dbContext, logger, appName!);
});

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