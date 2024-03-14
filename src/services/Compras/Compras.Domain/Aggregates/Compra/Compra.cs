using Common.WebAPI.Shared;
using Compras.Domain.Events;

namespace Compras.Domain.Aggregates
{
  public class Compra : Entity, IAggregateRoot
  {
    private readonly List<CompraItem> _compraItens = new();
    public IReadOnlyCollection<CompraItem> CompraItens => _compraItens;
    public Comprador Comprador { get; private set; } = null!;
    public DateTimeOffset DataHora { get; private set; }
    public decimal Total { get; private set; }

    public Compra() { }

    public Compra(Comprador comprador, List<CompraItem> compraItens)
    {
      Comprador = comprador;
      _compraItens = compraItens;
      Total = compraItens.Sum(_ => _.PrecoPago * _.Quantidade);
      DataHora = DateTimeOffset.UtcNow;

      AddDomainEvent(new CompraCriadaEvent(this));
    }

    public override string ToString()
    {
      return $"Compra {Id} / " +
        $"DataHora {DataHora} / " +
        $"Total {Total} " +
        $"Usuario {Comprador}";
    }
  }
}