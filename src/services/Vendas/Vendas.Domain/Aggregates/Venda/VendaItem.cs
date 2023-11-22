using Common.WebAPI.Shared;
using System.Text.Json;

namespace Vendas.Domain.Aggregates
{
  public class VendaItem : Entity
  {
    public string ProdutoId { get; private set; } = null!;
    public string Nome { get; private set; } = null!;
    public string ImageUrl { get; private set; } = null!;
    public string Descricao { get; private set; } = null!;
    public decimal Preco { get; private set; }
    public int Quantidade { get; private set; }
    public string UnidadeMedida { get; private set; } = null!;
    public long VendaId { get; private set; }
    public Venda Venda { get; private set; } = null!;

    public VendaItem() { }

    public VendaItem(string produtoId, string nome, string imageUrl, string descricao, decimal preco, int quantidade, string unidadeMedida)
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
      return JsonSerializer.Serialize(this);
    }
  }
}