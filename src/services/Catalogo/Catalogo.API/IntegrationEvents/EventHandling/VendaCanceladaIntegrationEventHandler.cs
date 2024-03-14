using Catalogo.API.Data.Repositories;
using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;

namespace Catalogo.API.IntegrationEvents.EventHandling
{
  public class VendaCanceladaIntegrationEventHandler : IIntegrationEventHandler<VendaCanceladaIntegrationEvent>
  {
    private readonly ILogger<VendaCanceladaIntegrationEvent> _logger;
    private readonly IProdutoRepository _produtoRepository;

    public VendaCanceladaIntegrationEventHandler(ILogger<VendaCanceladaIntegrationEvent> logger, IProdutoRepository produtoRepository)
    {
      _logger = logger;
      _produtoRepository = produtoRepository;
    }

    public async Task Handle(VendaCanceladaIntegrationEvent @event)
    {
      _logger.LogInformation("----- Handling integration event: {IntegrationEventId} - ({@IntegrationEvent})", @event.Id, @event);

      await _produtoRepository.EntradaEstoqueAsync(@event.VendaItens.ToDictionary(_ => _.ProdutoId, _ => _.Quantidade));
    }
  }
}