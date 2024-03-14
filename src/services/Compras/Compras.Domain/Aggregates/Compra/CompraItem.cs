using Common.WebAPI.Shared;

namespace Compras.Domain.Aggregates
{
  public class CompraItem : Entity
  {
    public string ProdutoId { get; private set; } = null!;
    public string Nome { get; private set; } = null!;
    public string ImageUrl { get; private set; } = null!;
    public string Descricao { get; private set; } = null!;
    public int EstoqueAtual { get; private set; }
    public decimal PrecoPago { get; private set; }
    public decimal PrecoSugerido { get; private set; }
    public bool IsPrecoMedioSugerido { get; private set; }
    public int Quantidade { get; private set; }
    public string UnidadeMedida { get; private set; } = null!;
    public long CompraId { get; private set; }
    public Compra Compra { get; private set; } = null!;

    public CompraItem() { }

    public CompraItem(string produtoId, string nome, string imageUrl, string descricao, int estoqueAtual, decimal precoPago, decimal precoSugerido, bool isPrecoMedioSugerido, int quantidade, string unidadeMedida)
    {
      ProdutoId = produtoId;
      Nome = nome;
      ImageUrl = imageUrl;
      Descricao = descricao;
      EstoqueAtual = estoqueAtual;
      PrecoPago = precoPago;
      PrecoSugerido = precoSugerido;
      IsPrecoMedioSugerido = isPrecoMedioSugerido;
      Quantidade = quantidade;
      UnidadeMedida = unidadeMedida;
    }

    public override string ToString()
    {
      return $"CompraItem {Id} / " +
        $"ProdutoId {ProdutoId} / " +
        $"Nome {Nome} / " +
        $"PrecoPago {PrecoPago} " +
        $"PrecoSugerido {PrecoSugerido}";
    }
  }
}
