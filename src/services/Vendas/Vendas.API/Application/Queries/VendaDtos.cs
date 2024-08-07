﻿using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Queries
{
  public record VendaItemto
  {
    public string ProdutoId { get; init; } = null!;
    public string Nome { get; init; } = null!;
    public string ImageUrl { get; init; } = null!;
    public decimal Preco { get; init; }
    public int Quantidade { get; init; }
    public string UnidadeMedida { get; init; } = null!;
  }

  public record VendaDto
  {
    public long Id { get; init; }
    public EnumVendaStatus Status { get; init; }
    public DateTimeOffset DataHora { get; set; }
    public decimal Total { get; init; }
    public string CompradorNome { get; init; } = null!;
    public string? CompradorFotoUrl { get; set; }

    public List<VendaItemto> Itens { get; init; } = new List<VendaItemto>();
  }

  public record VendaItemDetalheDto
  {
    public string ProdutoId { get; init; } = null!;
    public string Nome { get; init; } = null!;
    public string Descricao { get; set; } = null!;
    public string ImageUrl { get; init; } = null!;
    public decimal Preco { get; init; }
    public int Quantidade { get; init; }
    public string UnidadeMedida { get; init; } = null!;
  }

  public record VendaDetalheDto
  {
    public long Id { get; init; }
    public EnumVendaStatus Status { get; init; }
    public DateTimeOffset DataHora { get; set; }
    public decimal Total { get; init; }
    public string CompradorUserId { get; init; } = null!;

    public List<VendaItemDetalheDto> Itens { get; init; } = new List<VendaItemDetalheDto>();
  }
}