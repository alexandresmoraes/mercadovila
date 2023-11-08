using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Queries
{
  public record VendaItem
  {
    public string ProdutoId { get; private set; } = null!;
    public string Nome { get; private set; } = null!;
    public string ImageUrl { get; private set; } = null!;
    public decimal Preco { get; private set; }
    public int Quantidade { get; private set; }
    public string UnidadeMedida { get; private set; } = null!;
  }

  public record Venda
  {
    public EnumVendaStatus Status { get; private set; }
    public DateTime DataHora { get; private set; }
    public decimal Total { get; private set; }
  }

  public record VendaDetalhe
  {

  }
}
