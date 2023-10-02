using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Common.EventBus.Integrations
{
  public class IntegrationEventContext : DbContext
  {
    public IntegrationEventContext(DbContextOptions<IntegrationEventContext> options) : base(options)
    {
    }

    public DbSet<IntegrationEventLog> IntegrationEventLogs { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder builder)
    {
      builder.Entity<IntegrationEventLog>(ConfigureIntegrationEventLogEntry);
    }

    void ConfigureIntegrationEventLogEntry(EntityTypeBuilder<IntegrationEventLog> b)
    {
      b.ToTable("IntegrationEvent");

      b.HasKey(e => e.EventId);

      b.Property(e => e.EventId)
          .IsRequired();

      b.Property(e => e.Content)
          .IsRequired();

      b.Property(e => e.CreationTime)
          .IsRequired();

      b.Property(e => e.State)
          .IsRequired();

      b.Property(e => e.TimesSent)
          .IsRequired();

      b.Property(e => e.EventTypeName)
          .IsRequired();

    }
  }
}
