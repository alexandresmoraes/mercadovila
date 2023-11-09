using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Queries
{
  public record VendaItem
  {
    public string ProdutoId { get; init; } = null!;
    public string Nome { get; init; } = null!;
    public string ImageUrl { get; init; } = null!;
    public decimal Preco { get; init; }
    public int Quantidade { get; init; }
    public string UnidadeMedida { get; init; } = null!;
  }

  public record Venda
  {
    public long Id { get; init; }
    public EnumVendaStatus Status { get; init; }
    public DateTime DataHora { get; init; }
    public decimal Total { get; init; }
    public string CompradorNome { get; init; } = null!;
    public string? CompradorFotoUrl { get; set; }

    public List<VendaItem> Itens = new List<VendaItem>();
  }

  public record VendaItemDetalhe
  {
    public string ProdutoId { get; init; } = null!;
    public string Nome { get; init; } = null!;
    public string ImageUrl { get; init; } = null!;
    public decimal Preco { get; init; }
    public int Quantidade { get; init; }
    public string UnidadeMedida { get; init; } = null!;
  }

  public record VendaDetalhe
  {
    public long Id { get; init; }
    public EnumVendaStatus Status { get; init; }
    public DateTime DataHora { get; init; }
    public decimal Total { get; init; }

    public List<VendaItemDetalhe> Itens = new List<VendaItemDetalhe>();
  }
}
