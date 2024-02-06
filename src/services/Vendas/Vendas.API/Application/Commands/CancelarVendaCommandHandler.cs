using Common.WebAPI.Results;
using MediatR;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public class CancelarVendaCommandHandler
    : IRequestHandler<CancelarVendaCommand, Result>
  {
    private readonly IVendasRepository _vendasRepository;

    public CancelarVendaCommandHandler(IVendasRepository vendasRepository)
    {
      _vendasRepository = vendasRepository;
    }

    public async Task<Result> Handle(CancelarVendaCommand request, CancellationToken cancellationToken)
    {
      var venda = await _vendasRepository.GetAsync(request.VendaId);

      if (venda is null) return Result.NotFound();

      if (venda.Status == EnumVendaStatus.Pago)
        return Result.Fail($"Venda #{request.VendaId} encontra-se Pago.");

      venda.Cancelar();

      return Result.Ok();
    }
  }
}