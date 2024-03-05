using Common.WebAPI.Shared;
using Compras.Domain.Events;

namespace Compras.Domain.Aggregates
{
  public class Compra : Entity, IAggregateRoot
  {
    private readonly List<CompraItem> _compraItens = new List<CompraItem>();
    public IReadOnlyCollection<CompraItem> CompraItens => _compraItens;
    public DateTime DataHora { get; private set; }
    public decimal Total { get; private set; }

    public Compra() { }

    public Compra(IEnumerable<CompraItem> vendaItens)
    {
      _compraItens = vendaItens.ToList();
      Total = vendaItens.Sum(_ => _.Preco * _.Quantidade);
      DataHora = DateTime.UtcNow;

      AddDomainEvent(new CompraCriadaEvent(this));
    }

    public override string ToString()
    {
      return $"Compra {Id} / " +
        $"DataHora {DataHora} / " +
        $"Total {Total}";
    }
  }
}