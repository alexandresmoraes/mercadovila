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
      b.Property(_ => _.Id)
        .HasColumnName("id")
        .ValueGeneratedOnAdd();

      b.HasOne(_ => _.Comprador)
        .WithMany()
        .HasForeignKey("comprador_id")
        .IsRequired();

      b.Property(_ => _.Status)
        .HasColumnName("status")
       .IsRequired()
       .HasConversion(
           v => (int)v,
           v => (EnumVendaStatus)v);

      b.Property(_ => _.DataHora)
        .HasColumnName("datahora")
        .IsRequired();

      b.Property(_ => _.Total)
        .HasColumnName("total")
        .IsRequired();

      b.Ignore(_ => _.DomainEvents);
    }
  }
}