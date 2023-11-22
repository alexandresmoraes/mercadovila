using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Serilog;

namespace Common.WebAPI.Logs
{
  public static class SeriLogExtensions
  {
    public static ILoggingBuilder AddSerilog(this ILoggingBuilder logging, IConfiguration configuration)
    {
      Log.Logger = new LoggerConfiguration()
        .ReadFrom.Configuration(configuration)
        .CreateLogger();

      return logging;
    }

    public static IServiceCollection AddSerilog(this IServiceCollection services)
    {
      services.AddLogging(loggingBuilder =>
      {
        loggingBuilder.ClearProviders();
        loggingBuilder.AddSerilog();
      });

      return services;
    }
  }
}