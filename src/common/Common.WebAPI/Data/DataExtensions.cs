using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
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
  }
}