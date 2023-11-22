using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Vendas.Domain.Aggregates;

namespace Vendas.Infra.EntityMapping
{
  class VendaItemMapping : IEntityTypeConfiguration<VendaItem>
  {
    public void Configure(EntityTypeBuilder<VendaItem> b)
    {
      b.ToTable("venda_itens");

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

      b.Property(_ => _.Preco)
        .HasColumnName("preco")
        .IsRequired();

      b.Property(_ => _.Quantidade)
        .HasColumnName("quantidade")
        .IsRequired();

      b.Property(_ => _.UnidadeMedida)
        .HasColumnName("unidade_medida")
        .IsRequired();

      b.Property(_ => _.VendaId)
        .HasColumnName("venda_id");

      b.Ignore(_ => _.DomainEvents);
    }
  }
}
