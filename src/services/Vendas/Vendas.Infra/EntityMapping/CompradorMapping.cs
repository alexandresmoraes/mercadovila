using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Vendas.Domain.Aggregates;

namespace Vendas.Infra.EntityMapping
{
  class CompradorMapping : IEntityTypeConfiguration<Comprador>
  {
    public void Configure(EntityTypeBuilder<Comprador> builder)
    {
      builder.HasKey(c => c.Id);

      builder.Property(p => p.UserId).HasMaxLength(36);
      builder.HasIndex(p => p.UserId)
        .HasDatabaseName("comprador_userid_index")
        .IsUnique();

      builder.Property(c => c.Nome).IsRequired().HasMaxLength(256);
    }
  }
}