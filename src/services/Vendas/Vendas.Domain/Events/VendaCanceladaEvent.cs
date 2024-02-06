using MediatR;
using Vendas.Domain.Aggregates;

namespace Vendas.Domain.Events
{
  public record VendaCanceladaEvent : INotification
  {
    public Venda Venda { get; private set; }

    public VendaCanceladaEvent(Venda venda)
    {
      Venda = venda;
    }
  }
}