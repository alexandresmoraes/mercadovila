using Common.WebAPI.Shared;
using Vendas.Domain.Events;

namespace Vendas.Domain.Aggregates
{
  public class Venda : Entity, IAggregateRoot
  {
    private readonly List<VendaItem> _vendaItens = new();
    public IReadOnlyCollection<VendaItem> VendaItens => _vendaItens;
    public Comprador Comprador { get; private set; } = null!;
    public EnumVendaStatus Status { get; private set; }
    public DateTimeOffset DataHora { get; private set; }
    public decimal Total { get; private set; }

    public Venda() { }

    public Venda(Comprador comprador, IEnumerable<VendaItem> vendaItens)
    {
      Comprador = comprador;
      _vendaItens = vendaItens.ToList();
      Status = EnumVendaStatus.PendentePagamento;
      Total = vendaItens.Sum(_ => _.Preco * _.Quantidade);
      DataHora = DateTimeOffset.UtcNow;
    }

    public void Cancelar()
    {
      Status = EnumVendaStatus.Cancelada;

      AddDomainEvent(new VendaCanceladaEvent(this));
    }

    public void RealizarPagamento()
    {
      Status = EnumVendaStatus.Pago;
    }

    public void CancelarPagamento()
    {
      Status = EnumVendaStatus.PendentePagamento;
    }

    public override string ToString()
    {
      return $"Venda {Id} / " +
        $"Comprador {Comprador?.Nome} / " +
        $"Status {Status} / " +
        $"DataHora {DataHora} / " +
        $"Total {Total}";
    }
  }
}