using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Vendas.Domain.Aggregates;

namespace Vendas.Infra.EntityMapping
{
  sealed class PagamentoMapping : IEntityTypeConfiguration<Pagamento>
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

      b.HasMany(_ => _.Vendas)
        .WithOne()
        .HasForeignKey("pagamento_id")
        .OnDelete(DeleteBehavior.SetNull);

      b.Property(_ => _.Tipo)
        .HasColumnName("tipo")
        .IsRequired()
        .HasConversion(
          p => (int)p,
          p => (EnumTipoPagamento)p);

      b.Property(_ => _.Status)
        .HasColumnName("status")
        .IsRequired()
        .HasConversion(
          p => (int)p,
          p => (EnumStatusPagamento)p);

      b.Property(_ => _.DataHora)
        .HasColumnName("datahora")
        .IsRequired();

      b.Property(_ => _.Valor)
        .HasColumnName("valor")
        .IsRequired();

      b.Property(_ => _.RecebidoPorUserId)
        .HasColumnName("recebido_por_user_id")
        .HasMaxLength(36)
        .IsRequired();

      b.Property(_ => _.RecebidoPor)
        .HasColumnName("recebido_por")
        .HasMaxLength(128)
        .IsRequired();

      b.Property(_ => _.DataCancelamento)
        .HasColumnName("data_cancelamento");

      b.Property(_ => _.CanceladoPorUserId)
       .HasColumnName("cancelado_por_user_id")
       .HasMaxLength(36);

      b.Property(_ => _.CanceladoPor)
        .HasColumnName("cancelado_por")
        .HasMaxLength(128);

      b.Ignore(_ => _.DomainEvents);
    }
  }
}
