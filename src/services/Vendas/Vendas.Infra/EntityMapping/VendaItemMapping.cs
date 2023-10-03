﻿using Microsoft.EntityFrameworkCore;
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
      b.Property(e => e.Id).ValueGeneratedOnAdd();

      b.Property(_ => _.Nome)
        .IsRequired();

      b.Property(_ => _.ImageUrl)
        .IsRequired();

      b.Property(_ => _.Descricao)
        .IsRequired();

      b.Property(_ => _.Preco)
        .IsRequired();

      b.Property(_ => _.Quantidade)
        .IsRequired();

      b.Property(_ => _.UnidadeMedida)
        .IsRequired();

      b.Property(_ => _.VendaId);
      b.HasOne(_ => _.Venda)
        .WithMany(_ => _.VendaItens)
        .OnDelete(DeleteBehavior.Cascade);

      b.Ignore(_ => _.DomainEvents);
    }
  }
}