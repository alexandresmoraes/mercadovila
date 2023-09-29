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
    public string UnidadeMedida { get; set; }

    public VendaItem() { }
  }
}