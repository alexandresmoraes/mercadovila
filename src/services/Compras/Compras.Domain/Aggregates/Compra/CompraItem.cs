using Common.WebAPI.Shared;

namespace Compras.Domain.Aggregates
{
  public class CompraItem : Entity
  {
    public string ProdutoId { get; private set; } = null!;
    public string Nome { get; private set; } = null!;
    public string ImageUrl { get; private set; } = null!;
    public string Descricao { get; private set; } = null!;
    public decimal Preco { get; private set; }
    public int Quantidade { get; private set; }
    public string UnidadeMedida { get; private set; } = null!;
    public long CompraId { get; private set; }
    public Compra Compra { get; private set; } = null!;

    public CompraItem() { }

    public CompraItem(string produtoId, string nome, string imageUrl, string descricao, decimal preco, int quantidade, string unidadeMedida)
    {
      ProdutoId = produtoId;
      Nome = nome;
      ImageUrl = imageUrl;
      Descricao = descricao;
      Preco = preco;
      Quantidade = quantidade;
      UnidadeMedida = unidadeMedida;
    }

    public override string ToString()
    {
      return $"CompraItem {Id} / " +
        $"ProdutoId {ProdutoId} / " +
        $"Nome {Nome} / " +
        $"Preco {Preco}";
    }
  }
}
