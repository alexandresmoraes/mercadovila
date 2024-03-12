using Compras.Domain.Aggregates;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Compras.Infra.EntityMapping
{
  sealed class CompraMapping : IEntityTypeConfiguration<Compra>
  {
    public void Configure(EntityTypeBuilder<Compra> b)
    {
      b.ToTable("compras");

      b.HasKey(_ => _.Id);
      b.Property(_ => _.Id)
        .HasColumnName("id")
        .ValueGeneratedOnAdd();

      b.Property(_ => _.DataHora)
        .HasColumnName("datahora")
        .IsRequired();

      b.Property(_ => _.Total)
        .HasColumnName("total")
        .IsRequired();

      b.HasMany(_ => _.CompraItens)
        .WithOne(_ => _.Compra)
        .HasForeignKey(_ => _.CompraId)
        .OnDelete(DeleteBehavior.Cascade);

      b.Property(c => c.UsuarioId)
        .HasColumnName("usuario_id")
        .HasMaxLength(36)
        .IsRequired();

      b.Property(c => c.UsuarioUsername)
        .HasColumnName("usuario_username")
        .HasMaxLength(128)
        .IsRequired();

      b.Property(c => c.UsuarioNome)
       .HasColumnName("usuario_nome")
       .HasMaxLength(256)
       .IsRequired();

      b.Property(c => c.UsuarioEmail)
        .HasColumnName("usuario_email")
        .HasMaxLength(128)
        .IsRequired();

      b.Property(c => c.UsuarioFotoUrl)
        .HasColumnName("usuario_foto_url")
        .HasMaxLength(128);

      b.Ignore(_ => _.DomainEvents);
    }
  }
}