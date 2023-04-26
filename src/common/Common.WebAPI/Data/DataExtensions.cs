using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Common.WebAPI.Data
{
  public static class DataExtensions
  {
    public static WebApplication ApplyMigrations<TDbContext>(this WebApplication app) where TDbContext : DbContext
    {
      using var scope = app.Services.CreateScope();
      var db = scope.ServiceProvider.GetRequiredService<TDbContext>();
      db.Database.Migrate();
      return app;
    }

    public static DbContextOptionsBuilder UseNpgsql(this DbContextOptionsBuilder options, IConfiguration configuration)
    {
      options.UseNpgsql(configuration.GetConnectionString("Default"))
      .ReplaceService<ISqlGenerationHelper, NpgsqlSqlGenerationLowercasingHelper>();

      AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

      return options;
    }
  }
}