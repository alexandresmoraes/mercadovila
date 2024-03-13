using Catalogo.API.Data.Repositories;
using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;

namespace Catalogo.API.IntegrationEvents.EventHandling
{
  public class CompraCriadaIntegrationEventHandler : IIntegrationEventHandler<CompraCriadaIntegrationEvent>
  {
    private readonly ILogger<CompraCriadaIntegrationEventHandler> _logger;
    private readonly IProdutoRepository _produtoRepository;

    public CompraCriadaIntegrationEventHandler(ILogger<CompraCriadaIntegrationEventHandler> logger, IProdutoRepository produtoRepository)
    {
      _logger = logger;
      _produtoRepository = produtoRepository;
    }

    public async Task Handle(CompraCriadaIntegrationEvent @event)
    {
      _logger.LogInformation("----- Handling integration event: {IntegrationEventId} - ({@IntegrationEvent})", @event.Id, @event);

      var compraItens = @event.CompraItens.Select(_ => _.IsPrecoSugerido
        ? (_.ProdutoId, _.Quantidade, _.IsPrecoSugerido, _.PrecoPago)
        : (_.ProdutoId, _.Quantidade, _.IsPrecoSugerido, _.PrecoSugerido)).ToList();

      await _produtoRepository.EntradaEstoqueAndUpdatePrecoAsync(compraItens);
    }
  }
}