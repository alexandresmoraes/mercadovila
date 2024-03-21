using Common.EventBus;
using Common.EventBus.Abstractions;
using Common.EventBus.Integrations;
using Common.EventBus.Integrations.IntegrationEvents;
using Common.EventBus.Integrations.IntegrationLog;
using Microsoft.EntityFrameworkCore;
using System.Data.Common;
using System.Reflection;
using Vendas.API.IntegrationEvents.EventHandling;
using Vendas.Infra.Data;

namespace Vendas.API.Config
{
  public static class EventBusConfig
  {
    public static IServiceCollection AddEventBusConfig(this IServiceCollection services, IConfiguration configuration, string appName)
    {
      services.AddTransient<UsuarioAlteradoIntegrationEventHandler>();

      services.AddDbContext<IntegrationEventContext>(options =>
      {
        options.UseNpgsql(configuration.GetConnectionString("Default"),
          opt =>
          {
            opt.MigrationsAssembly(Assembly.GetAssembly(typeof(ApplicationDbContext))!.GetName().Name);
            opt.EnableRetryOnFailure(maxRetryCount: 15, maxRetryDelay: TimeSpan.FromSeconds(30), errorCodesToAdd: null);
          });
      });

      services.AddSingleton<IEventBusSubscriptionsManager, EventBusSubscriptionsManager>();
      services.AddSingleton<IEventBus, KafkaEventBus>(sp =>
      {
        var logger = sp.GetRequiredService<ILogger<KafkaEventBus>>();
        var eventBusSettings = sp.GetRequiredService<EventBusSettings>();
        var subManager = sp.GetRequiredService<IEventBusSubscriptionsManager>();

        return new KafkaEventBus(logger, eventBusSettings, sp, subManager);
      });
      services.AddScoped<Func<DbConnection, IIntegrationEventLogService>>(sp => (DbConnection c) => new IntegrationEventLogService(c));
      services.AddScoped<IIntegrationEventService, IntegrationEventService>((sp) =>
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

      return services;
    }

    public static void ConfigureEventBus(IApplicationBuilder app)
    {
      var eventBus = app.ApplicationServices.GetRequiredService<IEventBus>();

      eventBus.Subscribe<UsuarioAlteradoIntegrationEvent, UsuarioAlteradoIntegrationEventHandler>();
    }
  }
}