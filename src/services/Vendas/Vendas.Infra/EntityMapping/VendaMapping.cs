using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Vendas.Domain.Aggregates;

namespace Vendas.Infra.EntityMapping
{
  class VendaMapping : IEntityTypeConfiguration<Venda>
  {
    public void Configure(EntityTypeBuilder<Venda> b)
    {
      b.ToTable("vendas");

      b.HasKey(_ => _.Id);
      b.Property(e => e.Id).ValueGeneratedOnAdd();

      b.HasOne(_ => _.Comprador)
        .WithMany()
        .IsRequired();

      b.HasMany(v => v.VendaItens)
        .WithOne()
        .OnDelete(DeleteBehavior.Cascade);

      b.Property(v => v.Status)
       .IsRequired()
       .HasConversion(
           v => (int)v,
           v => (EnumVendaStatus)v);

      b.Property(_ => _.DataHora)
        .IsRequired();

      b.Property(v => v.Total)
        .IsRequired();

      b.Ignore(_ => _.DomainEvents);
    }
  }
}