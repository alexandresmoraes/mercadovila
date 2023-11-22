using Catalogo.API.Data.Repositories;
using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;

namespace Catalogo.API.IntegrationEvents.EventHandling
{
  public class VendaCriadaIntegrationEventHandler : IIntegrationEventHandler<VendaCriadaIntegrationEvent>
  {
    private readonly ICarrinhoItemRepository _carrinhoItemRepository;
    private readonly ILogger<VendaCriadaIntegrationEventHandler> _logger;

    public VendaCriadaIntegrationEventHandler(ICarrinhoItemRepository carrinhoItemRepository, ILogger<VendaCriadaIntegrationEventHandler> logger)
    {
      _carrinhoItemRepository = carrinhoItemRepository;
      _logger = logger;
    }

    public async Task Handle(VendaCriadaIntegrationEvent @event)
    {
      _logger.LogInformation("----- Handling integration event: {IntegrationEventId} - ({@IntegrationEvent})", @event.Id, @event);

      await _carrinhoItemRepository.RemoverCarrinhoPorUsuarioAsync(@event.UserId);
    }
  }
}