using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Vendas.Domain.Aggregates.Pagamento;

namespace Vendas.Infra.EntityMapping
{
  class PagamentoMapping : IEntityTypeConfiguration<Pagamento>
  {
    public void Configure(EntityTypeBuilder<Pagamento> b)
    {
      b.ToTable("pagamentos");

      b.HasKey(_ => _.Id);
      b.Property(_ => _.Id).ValueGeneratedOnAdd();

      b.HasOne(_ => _.Comprador)
        .WithMany()
        .IsRequired();

      b.HasMany(v => v.Vendas)
        .WithOne()
        .OnDelete(DeleteBehavior.Cascade);

      b.Property(_ => _.Tipo)
       .IsRequired()
       .HasConversion(
           v => (int)v,
           v => (EnumTipoPagamento)v);

      b.Property(_ => _.DataHora)
        .IsRequired();

      b.Property(_ => _.Valor)
        .IsRequired();

      b.Ignore(_ => _.DomainEvents);
    }
  }
}
