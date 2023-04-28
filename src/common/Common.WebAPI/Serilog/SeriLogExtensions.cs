using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Serilog;

namespace Common.WebAPI.Logs
{
  public static class SeriLogExtensions
  {
    public static ILoggingBuilder AddSerilog(this ILoggingBuilder logging, IConfiguration configuration)
    {
      logging.AddSerilog(new LoggerConfiguration()
        .ReadFrom.Configuration(configuration)
        .CreateLogger());

      return logging;
    }
  }
}