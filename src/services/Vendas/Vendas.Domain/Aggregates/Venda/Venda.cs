using Common.WebAPI.Shared;
using System.Text.Json;

namespace Vendas.Domain.Aggregates
{
  public class Venda : Entity, IAggregateRoot
  {
    private readonly List<VendaItem> _vendaItens = new List<VendaItem>();
    public IReadOnlyCollection<VendaItem> VendaItens => _vendaItens;
    public Comprador Comprador { get; private set; } = null!;
    public EnumVendaStatus Status { get; private set; }
    public DateTime DataHora { get; private set; }
    public decimal Total { get; private set; }

    public Venda() { }

    public Venda(Comprador comprador, IEnumerable<VendaItem> vendaItens)
    {
      Comprador = comprador;
      _vendaItens = vendaItens.ToList();
      Status = EnumVendaStatus.PendentePagamento;
      Total = vendaItens.Sum(_ => _.Preco * _.Quantidade);
      DataHora = DateTime.UtcNow;
    }

    public void Pagar()
    {
      Status = EnumVendaStatus.Pago;
    }

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}