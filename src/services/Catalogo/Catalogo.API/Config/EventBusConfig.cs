using Catalogo.API.IntegrationEvents.EventHandling;
using Common.EventBus;
using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;

namespace Catalogo.API.Config
{
  public static class EventBusConfig
  {
    public static IServiceCollection AddEventBusConfig(this IServiceCollection services, IConfiguration configuration)
    {
      services.AddTransient<VendaCanceladaIntegrationEventHandler>();
      services.AddTransient<VendaCriadaIntegrationEventHandler>();
      services.AddTransient<CompraCriadaIntegrationEventHandler>();


      services.AddSingleton<IEventBusSubscriptionsManager, EventBusSubscriptionsManager>();
      services.AddSingleton<IEventBus, KafkaEventBus>(sp =>
      {
        var logger = sp.GetRequiredService<ILogger<KafkaEventBus>>();
        var eventBusSettings = sp.GetRequiredService<EventBusSettings>();
        var subManager = sp.GetRequiredService<IEventBusSubscriptionsManager>();

        return new KafkaEventBus(logger, eventBusSettings, sp, subManager);
      });

      return services;
    }

    public static void ConfigureEventBus(IApplicationBuilder app)
    {
      var eventBus = app.ApplicationServices.GetRequiredService<IEventBus>();

      eventBus.Subscribe<VendaCanceladaIntegrationEvent, VendaCanceladaIntegrationEventHandler>();
      eventBus.Subscribe<VendaCriadaIntegrationEvent, VendaCriadaIntegrationEventHandler>();
      eventBus.Subscribe<CompraCriadaIntegrationEvent, CompraCriadaIntegrationEventHandler>();
    }
  }
}