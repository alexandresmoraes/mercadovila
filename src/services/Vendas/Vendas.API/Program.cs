using Common.EventBus.Integrations;
using Common.Grpc;
using Common.WebAPI.Logs;
using Common.WebAPI.Notifications;
using Common.WebAPI.PostgreSql;
using GrpcVendas;
using Microsoft.EntityFrameworkCore;
using Serilog;
using System.Data;
using System.Reflection;
using Vendas.API.Application.Queries;
using Vendas.API.Config;
using Vendas.Infra.Data;

var appName = Assembly.GetEntryAssembly()!.GetName().Name;

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

builder.Services.AddScoped<INotificationsContext, NotificationsContext>();

builder.Services.AddEventBusConfig(builder.Configuration, appName!);

Log.Logger = CreateSerilogLogger(builder.Configuration);

try
{
  Log.Information("Configuring web app ({ApplicationContext})...", appName);
  var app = builder.Build();

  EventBusConfig.ConfigureEventBus(app);

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

