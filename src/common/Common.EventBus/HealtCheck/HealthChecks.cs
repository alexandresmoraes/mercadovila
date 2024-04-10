using Confluent.Kafka;
using Microsoft.Extensions.DependencyInjection;

namespace Common.EventBus.HealtCheck
{
  public static class HealthChecks
  {
    public static IServiceCollection AddHealthCheckKafka(this IServiceCollection services, string connectionString)
    {
      services.AddHealthChecks().AddKafka(new ProducerConfig()
      {
        BootstrapServers = connectionString
      }, name: "kafka", tags: new string[] { "broker" });

      return services;
    }
  }
}
