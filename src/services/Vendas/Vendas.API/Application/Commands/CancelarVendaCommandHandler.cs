using Common.WebAPI.Results;
using MediatR;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public class CancelarVendaCommandHandler : IRequestHandler<CancelarVendaCommand, Result>
  {
    private readonly ILogger<CancelarVendaCommandHandler> _logger;
    private readonly IVendasRepository _vendasRepository;

    public CancelarVendaCommandHandler(ILogger<CancelarVendaCommandHandler> logger, IVendasRepository vendasRepository)
    {
      _logger = logger;
      _vendasRepository = vendasRepository;
    }

    public async Task<Result> Handle(CancelarVendaCommand request, CancellationToken cancellationToken)
    {
      _logger.LogTrace("Venda: {VendaId} cancelar.", request.VendaId);

      var venda = await _vendasRepository.GetAsync(request.VendaId);

      if (venda is null) return Result.NotFound();

      if (venda.Status == EnumVendaStatus.Pago)
        return Result.Fail($"Venda #{request.VendaId} encontra-se Pago.");

      if (venda.Status == EnumVendaStatus.Cancelada)
        return Result.Fail($"Venda #{request.VendaId} encontra-se Cancelada.");

      venda.Cancelar();

      return Result.Ok();
    }
  }
}