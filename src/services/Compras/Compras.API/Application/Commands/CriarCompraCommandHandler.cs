using Common.EventBus.Integrations.IntegrationEvents;
using Common.EventBus.Integrations.IntegrationLog;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Compras.API.Application.Responses;
using Compras.Domain.Aggregates;
using MediatR;

namespace Compras.API.Application.Commands
{
  public class CriarCompraCommandHandler : IRequestHandler<CriarCompraCommand, Result<CriarCompraCommandResponse>>
  {
    private readonly IAuthService _authService;
    private readonly IComprasRepository _comprasRepository;
    private readonly IIntegrationEventService _integrationEventService;



    public async Task<Result<CriarCompraCommandResponse>> Handle(CriarCompraCommand request, CancellationToken cancellationToken)
    {
      var userId = _authService.GetUserId();
      var userEmail = _authService.GetUserEmail();

      var compra = new Compra(
        userId: userId,
        userEmail: userEmail,
        userFotoUrl: request.UserFotoUrl,
        compraItens: request.CompraItens.Select(item => new CompraItem(
          item.ProdutoId,
          item.Nome,
          item.ImageUrl,
          item.Descricao,
          item.EstoqueAtual,
          item.PrecoPago,
          item.PrecoSugerido,
          item.IsPrecoMedioSugerido,
          item.Quantidade,
          item.UnidadeMedida
        ))
      );

      await _comprasRepository.AddAsync(compra);

      var vendaCriadaIntegrationEvent = new VendaCriadaIntegrationEvent(userId);
      await _integrationEventService.AddAndSaveEventAsync(vendaCriadaIntegrationEvent);

      return Result.Created($"api/compras/{compra.Id}", new CriarCompraCommandResponse(compra.Id));
    }
  }
}