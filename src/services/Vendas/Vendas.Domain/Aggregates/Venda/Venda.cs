using Common.WebAPI.Shared;

namespace Vendas.Domain.Aggregates
{
  public class Venda : Entity, IAggregateRoot
  {
    public Comprador Comprador { get; set; } = null!;

    private readonly List<VendaItem> _vendaItens = new List<VendaItem>();
    public IReadOnlyCollection<VendaItem> VendaItens => _vendaItens;
    public EnumVendaStatus Status { get; set; }
    public DateTime DataHora { get; set; }

    public decimal Total { get; set; }

    public Venda() { }

    public Venda(Comprador comprador, IEnumerable<VendaItem> vendaItens, EnumVendaStatus status)
    {
      Comprador = comprador;
      _vendaItens = vendaItens.ToList();
      Status = status;
      Total = vendaItens.Sum(_ => _.Preco * _.Quantidade);
      DataHora = DateTime.Now;
    }
  }
}