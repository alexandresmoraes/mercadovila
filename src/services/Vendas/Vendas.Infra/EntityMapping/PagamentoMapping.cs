using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Vendas.Domain.Aggregates;

namespace Vendas.Infra.EntityMapping
{
  class PagamentoMapping : IEntityTypeConfiguration<Pagamento>
  {
    public void Configure(EntityTypeBuilder<Pagamento> b)
    {
      b.ToTable("pagamentos");

      b.HasKey(_ => _.Id);
      b.Property(_ => _.Id)
        .HasColumnName("id")
        .ValueGeneratedOnAdd();

      b.HasOne(_ => _.Comprador)
        .WithMany()
        .HasForeignKey("comprador_id")
        .IsRequired();

      b.HasMany(v => v.Vendas)
        .WithOne()
        .HasForeignKey("pagamento_id")
        .OnDelete(DeleteBehavior.Cascade);

      b.Property(_ => _.Tipo)
        .HasColumnName("tipo")
        .IsRequired()
        .HasConversion(
          v => (int)v,
          v => (EnumTipoPagamento)v);

      b.Property(_ => _.DataHora)
        .HasColumnName("datahora")
        .IsRequired();

      b.Property(_ => _.Valor)
        .HasColumnName("valor")
        .IsRequired();

      b.Ignore(_ => _.DomainEvents);
    }
  }
}
