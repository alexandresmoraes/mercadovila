using Common.WebAPI.PostgreSql;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Serilog;
using Vendas.Domain.Aggregates;
using Vendas.Domain.Aggregates.Pagamento;
using Vendas.Infra.EntityMapping;

namespace Vendas.Infra.Data
{
  public class ApplicationDbContext : DbContext
  {
    protected readonly IConfiguration _configuration;

    public ApplicationDbContext(IConfiguration configuration)
    {
      _configuration = configuration;
    }

    public DbSet<Comprador> Compradores { get; set; } = null!;
    public DbSet<Venda> Vendas { get; set; } = null!;
    public DbSet<VendaItem> VendaItens { get; set; } = null!;
    public DbSet<Pagamento> Pagamentos { get; set; } = null!;

    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
      options.UseNpgsql(_configuration);
      options.UseLoggerFactory(LoggerFactory.Create(builder => builder.AddSerilog()));
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      modelBuilder.ApplyConfiguration(new CompradorMapping());
      modelBuilder.ApplyConfiguration(new VendaMapping());
      modelBuilder.ApplyConfiguration(new PagamentoMapping());
      modelBuilder.ApplyConfiguration(new VendaItemMapping());
    }
  }
}