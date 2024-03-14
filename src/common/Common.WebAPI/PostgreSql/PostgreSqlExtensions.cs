using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Polly;

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

    public static DbContextOptionsBuilder UseNpgsqlExtension(this DbContextOptionsBuilder options, IConfiguration configuration)
    {
      options
        .UseNpgsql(configuration.GetConnectionString("Default"));

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

    public static WebApplication MigrateDbContext<TContext>(this WebApplication app, Action<TContext, IServiceProvider> seeder) where TContext : DbContext
    {
      using var scope = app.Services.CreateScope();
      var services = scope.ServiceProvider;
      var logger = services.GetRequiredService<ILogger<TContext>>();
      var context = services.GetService<TContext>();

      try
      {
        logger.LogInformation("Migrating database associated with context {DbContextName}", typeof(TContext).Name);

        var retries = 10;
        var retry = Policy.Handle<Exception>()
            .WaitAndRetry(
                retryCount: retries,
                sleepDurationProvider: retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)),
                onRetry: (exception, timeSpan, retry, ctx) =>
                {
                  logger.LogWarning(exception, "[{prefix}] Exception {ExceptionType} with message {Message} detected on attempt {retry} of {retries}", nameof(TContext), exception.GetType().Name, exception.Message, retry, retries);
                });

        retry.Execute(() => InvokeSeeder(seeder!, context!, services));

        logger.LogInformation("Migrated database associated with context {DbContextName}", typeof(TContext).Name);
      }
      catch (Exception ex)
      {
        logger.LogError(ex, "An error occurred while migrating the database used on context {DbContextName}", typeof(TContext).Name);
      }

      return app;
    }

    private static void InvokeSeeder<TContext>(Action<TContext, IServiceProvider> seeder, TContext context, IServiceProvider services)
            where TContext : DbContext
    {
      context.Database.Migrate();
      seeder(context, services);
    }
  }
}