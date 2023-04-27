﻿using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Common.WebAPI.Data
{
  public static class DataExtensions
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
        .UseNpgsql(configuration.GetConnectionString("Default"))
        .ReplaceService<ISqlGenerationHelper, NpgsqlSqlGenerationLowercasingHelper>();

      AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

      return options;
    }

    public static IServiceCollection AddUnitOfWork<TDbContext>(this IServiceCollection services)
      where TDbContext : DbContext
    {
      services.AddMvc(opt =>
      {
        opt.Filters.Add<UnitOfWorkCommitAttribute<TDbContext>>();
        opt.Filters.Add<UnitOfWorkExceptionAttribute<TDbContext>>();
      });

      return services;
    }
  }
}