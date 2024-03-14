using Catalogo.API.Data.Repositories;
using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;

namespace Catalogo.API.IntegrationEvents.EventHandling
{
  public class VendaCriadaIntegrationEventHandler : IIntegrationEventHandler<VendaCriadaIntegrationEvent>
  {
    private readonly ILogger<VendaCriadaIntegrationEventHandler> _logger;
    private readonly ICarrinhoItemRepository _carrinhoItemRepository;
    private readonly IProdutoRepository _produtoRepository;

    public VendaCriadaIntegrationEventHandler(ILogger<VendaCriadaIntegrationEventHandler> logger, ICarrinhoItemRepository carrinhoItemRepository, IProdutoRepository produtoRepository)
    {
      _logger = logger;
      _carrinhoItemRepository = carrinhoItemRepository;
      _produtoRepository = produtoRepository;
    }

    public async Task Handle(VendaCriadaIntegrationEvent @event)
    {
      _logger.LogInformation("----- Handling integration event: {IntegrationEventId} - ({@IntegrationEvent})", @event.Id, @event);

      await _carrinhoItemRepository.RemoverCarrinhoPorUsuarioAsync(@event.UserId);
      await _produtoRepository.AtualizarQuantidadeVendidaDataUltimaVenda(@event.Itens);
    }
  }
}