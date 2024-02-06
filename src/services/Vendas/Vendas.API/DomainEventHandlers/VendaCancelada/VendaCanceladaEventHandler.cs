using Common.EventBus.Integrations.IntegrationEvents;
using Common.EventBus.Integrations.IntegrationLog;
using MediatR;
using Vendas.Domain.Events;

namespace Vendas.API.DomainEventHandlers.VendaCancelada
{
  public class VendaCanceladaEventHandler
    : INotificationHandler<VendaCanceladaEvent>
  {
    private readonly ILogger<VendaCanceladaEvent> _logger;
    private readonly IIntegrationEventService _integrationEventService;

    public VendaCanceladaEventHandler(ILogger<VendaCanceladaEvent> logger, IIntegrationEventService integrationEventService)
    {
      _logger = logger;
      _integrationEventService = integrationEventService;
    }

    public async Task Handle(VendaCanceladaEvent vendaCanceladaEvent, CancellationToken cancellationToken)
    {
      _logger.LogTrace("Venda com Id: {VendaId} foi cancelada.", vendaCanceladaEvent.Venda.Id);

      var vendaItens = vendaCanceladaEvent.Venda.VendaItens
        .Select(_ => new VendaCanceladaItemIntegrationEvent(
          produtoId: _.ProdutoId,
          quantidade: _.Quantidade,
          preco: _.Preco
        ));

      var vendaCanceladaIntegrationEvent = new VendaCanceladaIntegrationEvent(
        vendaId: vendaCanceladaEvent.Venda.Id,
        userId: vendaCanceladaEvent.Venda.Comprador.UserId,
        vendaItens: vendaItens.ToList()
      );

      await _integrationEventService.AddAndSaveEventAsync(vendaCanceladaIntegrationEvent);
    }
  }
}
