using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace Common.EventBus
{
  public static class PostgreSqlExtensions
  {
    public static DbContextOptionsBuilder UseNpgsqlIntegrationContext(this DbContextOptionsBuilder options,
      IConfiguration configuration,
      string appName)
    {
      options.UseNpgsql(configuration.GetConnectionString("Default"), b => b.MigrationsAssembly(appName));

      AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

      return options;
    }
  }
}
