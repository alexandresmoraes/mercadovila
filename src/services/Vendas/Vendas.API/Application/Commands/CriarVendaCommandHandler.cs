using Common.EventBus.Integrations.IntegrationEvents;
using Common.EventBus.Integrations.IntegrationLog;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using GrpcVendas;
using MediatR;
using Vendas.API.Application.Responses;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public class CriarVendaCommandHandler : IRequestHandler<CriarVendaCommand, Result<CriarVendaCommandResponse>>
  {
    private readonly ICompradoresRepository _compradorRepository;
    private readonly IVendasRepository _vendaRepository;
    private readonly IAuthService _authService;
    private readonly Carrinho.CarrinhoClient _carrinhoClient;
    private readonly IIntegrationEventService _integrationEventService;

    public CriarVendaCommandHandler(ICompradoresRepository compradorRepository, IVendasRepository vendaRepository, IAuthService authService, Carrinho.CarrinhoClient carrinhoClient, IIntegrationEventService integrationEventService)
    {
      _compradorRepository = compradorRepository;
      _vendaRepository = vendaRepository;
      _authService = authService;
      _carrinhoClient = carrinhoClient;
      _integrationEventService = integrationEventService;
    }

    public async Task<Result<CriarVendaCommandResponse>> Handle(CriarVendaCommand request, CancellationToken cancellationToken)
    {
      var userId = _authService.GetUserId();

      var carrinhoRequest = new CarrinhoRequest { UserId = userId };
      var carrinho = await _carrinhoClient.GetCarrinhoReservarEstoquePorUsuarioAsync(carrinhoRequest);

      if (carrinho is null)
        return Result.Fail<CriarVendaCommandResponse>("Não foi possível obter o carrinho de compras");

      if (!carrinho.Itens.Any())
        return Result.Fail<CriarVendaCommandResponse>("Sem itens no carrinho de compras");

      var countIndisponiveis = carrinho.Itens.Count(_ => _.DisponibilidadeEstoque == false);
      if (countIndisponiveis > 0)
      {
        var failMessage = countIndisponiveis > 1 ? "Itens indisponíveis, confira o carrinho." : "Item indisponível, confira o carrinho.";
        return Result.Fail<CriarVendaCommandResponse>(failMessage);
      }

      var comprador = await _compradorRepository.GetAsync(userId);
      if (comprador is null)
      {
        comprador = new Comprador(userId, request.CompradorNome, _authService.GetUserEmail(), request.CompradorFotoUrl);
      }
      else
      {
        comprador.Nome = request.CompradorNome;
        comprador.Email = _authService.GetUserEmail();
        comprador.FotoUrl = request.CompradorFotoUrl;
      }

      var venda = new Venda(
        comprador: comprador,
        vendaItens: carrinho.Itens.Select(item => new VendaItem(
          item.Id,
          item.Nome,
          item.ImageUrl,
          item.Descricao,
          (decimal)item.Preco,
          item.Quantidade,
          item.UnidadeMedida
        ))
      );

      await _vendaRepository.AddAsync(venda);

      var vendaCriadaIntegrationEvent = new VendaCriadaIntegrationEvent(userId, venda.VendaItens.ToDictionary(_ => _.ProdutoId, _ => _.Quantidade));
      await _integrationEventService.AddAndSaveEventAsync(vendaCriadaIntegrationEvent);

      return Result.Created($"api/vendas/{venda.Id}", new CriarVendaCommandResponse(venda.Id));
    }
  }
}