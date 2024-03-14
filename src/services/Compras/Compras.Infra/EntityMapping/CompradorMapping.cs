using Compras.Domain.Aggregates;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Compras.Infra.EntityMapping
{
  sealed class CompradorMapping : IEntityTypeConfiguration<Comprador>
  {
    public void Configure(EntityTypeBuilder<Comprador> b)
    {
      b.ToTable("compradores");

      b.HasKey(c => c.UserId);

      b.Property(c => c.UserId)
        .HasMaxLength(36)
        .HasColumnName("user_id")
        .IsRequired();

      b.Property(c => c.Nome)
        .HasColumnName("nome")
        .IsRequired()
        .HasMaxLength(256);

      b.Property(c => c.Username)
        .HasColumnName("usuario_username")
        .HasMaxLength(128)
        .IsRequired();

      b.Property(c => c.Email)
        .HasColumnName("email")
        .IsRequired()
        .HasMaxLength(256);

      b.Property(c => c.FotoUrl)
        .HasColumnName("foto_url")
        .HasMaxLength(256);

      b.Ignore(c => c.Id);
      b.Ignore(c => c.DomainEvents);
    }
  }
}