using MediatR;
using Vendas.Domain.Aggregates;

namespace Vendas.Domain.Events
{
  public record VendaCanceladaEvent : INotification
  {
    public Venda Venda { get; private init; }

    public VendaCanceladaEvent(Venda venda)
    {
      Venda = venda;
    }

    public override string ToString()
    {
      return $"Venda Cancelada / {Venda}";
    }
  }
}