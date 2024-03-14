using Common.WebAPI.Results;
using MediatR;

namespace Vendas.API.Application.Commands
{
  public record CancelarVendaCommand : IRequest<Result>
  {
    public long VendaId { get; private init; }

    public CancelarVendaCommand(long vendaId)
    {
      VendaId = vendaId;
    }
  }
}