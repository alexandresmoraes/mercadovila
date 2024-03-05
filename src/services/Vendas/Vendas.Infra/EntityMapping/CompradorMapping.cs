using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Vendas.Domain.Aggregates;

namespace Vendas.Infra.EntityMapping
{
  sealed class CompradorMapping : IEntityTypeConfiguration<Comprador>
  {
    public void Configure(EntityTypeBuilder<Comprador> b)
    {
      b.ToTable("compradores");

      b.HasKey(c => c.Id);
      b.Property(e => e.Id)
        .HasColumnName("id")
        .ValueGeneratedOnAdd();

      b.Property(p => p.UserId)
        .HasMaxLength(36)
        .HasColumnName("user_id")
        .IsRequired();
      b.HasIndex(p => p.UserId)
        .HasDatabaseName("comprador_userid_index")
        .IsUnique();

      b.Property(c => c.Nome)
        .HasColumnName("nome")
        .IsRequired()
        .HasMaxLength(256);

      b.Property(c => c.Email)
        .HasColumnName("email")
        .IsRequired()
        .HasMaxLength(256);

      b.Property(c => c.FotoUrl)
        .HasColumnName("foto_url")
        .HasMaxLength(256);

      b.Ignore(_ => _.DomainEvents);
    }
  }
}