using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Common.WebAPI.PostgreSql
{
  public static class PostgreSqlExtensions
  {
    public static WebApplication RunMigrations<TDbContext>(this WebApplication app) where TDbContext : DbContext
    {
      using var scope = app.Services.CreateScope();
      var context = scope.ServiceProvider.GetRequiredService<TDbContext>();
      context.Database.Migrate();
      return app;
    }

    public static DbContextOptionsBuilder UseNpgsql(this DbContextOptionsBuilder options, IConfiguration configuration)
    {
      options
        .UseNpgsql(configuration.GetConnectionString("Default"));
      //.ReplaceService<ISqlGenerationHelper, NpgsqlSqlGenerationLowercasingHelper>();

      AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

      return options;
    }

    public static IServiceCollection AddUnitOfWorkPostgres(this IServiceCollection services)
    {
      services.AddScoped<IUnitOfWork, UnitOfWork>();

      services.AddMvc(opt =>
      {
        opt.Filters.Add<UnitOfWorkAttribute>();
        opt.Filters.Add<UnitOfWorkExceptionAttribute>();
      });

      return services;
    }

    public static IHealthChecksBuilder AddPostgresHealthCheck(this IHealthChecksBuilder checkBuilder, IConfiguration configuration)
    {
      var connectionString = configuration.GetConnectionString("Default");

      if (string.IsNullOrEmpty(connectionString))
        throw new ArgumentException("Default connectionString is empty");

      return checkBuilder.AddNpgSql(connectionString, name: "postgres", tags: new[] { "infra" });
    }
  }
}