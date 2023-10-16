using Common.EventBus.Abstractions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Common.EventBus
{
    public static class EventBusExtensions
  {
    public static IServiceCollection AddEventBus(this IServiceCollection services, IConfiguration configuration)
    {
      var eventBusSettings = configuration.GetSection(nameof(EventBusSettings));

      if (eventBusSettings.Value is null)
        throw new ArgumentException(nameof(eventBusSettings));

      services.Configure<EventBusSettings>(eventBusSettings);

      services.AddScoped<IConsumer, Consumer>();
      services.AddScoped<IProducer, Producer>();

      return services;
    }
  }
}