using Common.WebAPI.PostgreSql;
using Compras.Domain.Aggregates;
using Compras.Infra.EntityMapping;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Serilog;

namespace Compras.Infra.Data
{
  public class ApplicationDbContext : DbContext
  {
    protected readonly IConfiguration _configuration;

    public ApplicationDbContext(IConfiguration configuration)
    {
      _configuration = configuration;
    }

    public DbSet<Compra> Compras { get; set; } = null!;
    public DbSet<CompraItem> CompraItens { get; set; } = null!;
    public DbSet<Comprador> Compradores { get; set; } = null!;

    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
      options.UseNpgsqlExtension(_configuration);
      options.UseLoggerFactory(LoggerFactory.Create(builder => builder.AddSerilog()));
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      modelBuilder.ApplyConfiguration(new CompraMapping());
      modelBuilder.ApplyConfiguration(new CompraItemMapping());
      modelBuilder.ApplyConfiguration(new CompradorMapping());
    }
  }
}
