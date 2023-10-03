using Common.WebAPI.Shared;

namespace Vendas.Domain.Aggregates
{
  public class VendaItem : Entity
  {
    public string Nome { get; private set; } = null!;
    public string ImageUrl { get; private set; } = null!;
    public string Descricao { get; private set; } = null!;
    public decimal Preco { get; private set; }
    public int Quantidade { get; private set; }
    public string UnidadeMedida { get; set; } = null!;
    public long VendaId { get; set; }
    public Venda Venda { get; set; } = null!;

    public VendaItem() { }

    public VendaItem(string nome, string imageUrl, string descricao, decimal preco, int quantidade, string unidadeMedida)
    {
      Nome = nome;
      ImageUrl = imageUrl;
      Descricao = descricao;
      Preco = preco;
      Quantidade = quantidade;
      UnidadeMedida = unidadeMedida;
    }
  }
}