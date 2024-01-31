using Common.WebAPI.Results;
using MediatR;

namespace Vendas.API.Application.Commands
{
  public class CancelarPagamentoCommandHandler
    : IRequestHandler<CancelarPagamentoCommand, Result>
  {
    public Task<Result> Handle(CancelarPagamentoCommand request, CancellationToken cancellationToken)
    {
      throw new NotImplementedException();
    }
  }
}