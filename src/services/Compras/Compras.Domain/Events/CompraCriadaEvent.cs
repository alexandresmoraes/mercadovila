using Compras.Domain.Aggregates;
using MediatR;

namespace Compras.Domain.Events
{
  public record CompraCriadaEvent : INotification
  {
    public Compra Compra { get; private init; }

    public CompraCriadaEvent(Compra compra)
    {
      Compra = compra;
    }

    public override string ToString()
    {
      return $"Nova Compra / {Compra}";
    }
  }
}