﻿using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Vendas.Domain.Aggregates;

namespace Vendas.Infra.EntityMapping
{
  class CompradorMapping : IEntityTypeConfiguration<Comprador>
  {
    public void Configure(EntityTypeBuilder<Comprador> b)
    {
      b.ToTable("compradores");

      b.HasKey(c => c.Id);
      b.Property(e => e.Id).ValueGeneratedOnAdd();

      b.Property(p => p.UserId)
        .HasMaxLength(36);

      b.HasIndex(p => p.UserId)
        .HasDatabaseName("comprador_userid_index")
        .IsUnique();

      b.Property(c => c.Nome)
        .IsRequired()
        .HasMaxLength(256);

      b.Ignore(_ => _.DomainEvents);
    }
  }
}