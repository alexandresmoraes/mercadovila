using Common.WebAPI.Results;
using MediatR;

namespace Vendas.API.Application.Commands
{
  public class CancelarVendaCommandHandler
    : IRequestHandler<CancelarVendaCommand, Result>
  {
    public Task<Result> Handle(CancelarVendaCommand request, CancellationToken cancellationToken)
    {
      throw new NotImplementedException();
    }
  }
}