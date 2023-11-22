using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Common.EventBus.Integrations
{
  public class IntegrationEventContext : DbContext
  {
    public IntegrationEventContext(DbContextOptions<IntegrationEventContext> options) : base(options) { }

    public DbSet<IntegrationEventLog> IntegrationEventLogs { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder builder)
    {
      builder.Entity<IntegrationEventLog>(ConfigureIntegrationEventLogEntry);
    }

    void ConfigureIntegrationEventLogEntry(EntityTypeBuilder<IntegrationEventLog> b)
    {
      b.ToTable("integration_event");

      b.HasKey(e => e.EventId);

      b.Property(e => e.EventId)
        .HasColumnName("entity_id")
        .IsRequired();

      b.Property(e => e.Content)
        .HasColumnName("content")
        .IsRequired();

      b.Property(e => e.CreationTime)
        .HasColumnName("creation_time")
        .IsRequired();

      b.Property(e => e.State)
        .HasColumnName("state")
        .IsRequired();

      b.Property(e => e.TimesSent)
        .HasColumnName("times_sent")
        .IsRequired();

      b.Property(e => e.EventTypeName)
        .HasColumnName("event_type_name")
        .IsRequired();

      b.Property(e => e.TransactionId)
        .HasColumnName("transaction_id")
        .IsRequired();
    }
  }
}
