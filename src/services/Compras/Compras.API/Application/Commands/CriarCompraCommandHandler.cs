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

    public CriarCompraCommandHandler(IAuthService authService, IComprasRepository comprasRepository, IIntegrationEventService integrationEventService)
    {
      _authService = authService;
      _comprasRepository = comprasRepository;
      _integrationEventService = integrationEventService;
    }

    public async Task<Result<CriarCompraCommandResponse>> Handle(CriarCompraCommand request, CancellationToken cancellationToken)
    {
      var usuarioId = _authService.GetUserId();
      var usuarioUsername = _authService.GetUserName();
      var usuarioEmail = _authService.GetUserEmail();

      var compra = new Compra(
        usuarioId: usuarioId,
        usuarioUsername: usuarioUsername,
        usuarioEmail: usuarioEmail,
        usuarioNome: request.UsuarioNome,
        usuarioFotoUrl: request.UsuarioFotoUrl,
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
        )).ToList()
      );

      await _comprasRepository.AddAsync(compra);

      var compraItens = compra.CompraItens.Select(item => new CompraCriadaItemIntegrationEvent(
        produtoId: item.ProdutoId,
        quantidade: item.Quantidade,
        precoPago: item.PrecoPago,
        precoSugerido: item.IsPrecoMedioSugerido ? null : item.PrecoSugerido,
        isPrecoSugerido: item.IsPrecoMedioSugerido
      )).ToList();
      var compraCriadaIntegrationEvent = new CompraCriadaIntegrationEvent(compra.Id, usuarioId, compraItens);

      await _integrationEventService.AddAndSaveEventAsync(compraCriadaIntegrationEvent);

      return Result.Created($"api/compras/{compra.Id}", new CriarCompraCommandResponse(compra.Id));
    }
  }
}