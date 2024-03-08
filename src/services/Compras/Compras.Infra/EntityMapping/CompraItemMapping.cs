using Compras.Domain.Aggregates;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Compras.Infra.EntityMapping
{
  sealed class CompraItemMapping : IEntityTypeConfiguration<CompraItem>
  {
    public void Configure(EntityTypeBuilder<CompraItem> b)
    {
      b.ToTable("compra_itens");

      b.HasKey(c => c.Id);
      b.Property(e => e.Id)
        .HasColumnName("id")
        .ValueGeneratedOnAdd();

      b.Property(_ => _.ProdutoId)
        .HasColumnName("produto_id")
        .HasMaxLength(36)
        .IsRequired();

      b.Property(_ => _.Nome)
        .HasColumnName("nome")
        .IsRequired();

      b.Property(_ => _.ImageUrl)
        .HasColumnName("image_url")
        .IsRequired();

      b.Property(_ => _.Descricao)
        .HasColumnName("descricao")
        .IsRequired();

      b.Property(_ => _.EstoqueAtual)
        .HasColumnName("estoque_atual")
        .IsRequired();

      b.Property(_ => _.PrecoPago)
        .HasColumnName("preco_pago")
        .IsRequired();

      b.Property(_ => _.PrecoSugerido)
        .HasColumnName("preco_sugerido")
        .IsRequired();

      b.Property(_ => _.IsPrecoMedioSugerido)
        .HasColumnName("preco_medio_sugerido")
        .IsRequired();

      b.Property(_ => _.Quantidade)
        .HasColumnName("quantidade")
        .IsRequired();

      b.Property(_ => _.UnidadeMedida)
        .HasColumnName("unidade_medida")
        .IsRequired();

      b.Property(_ => _.CompraId)
        .HasColumnName("compra_id");

      b.Ignore(_ => _.DomainEvents);
    }
  }
}
