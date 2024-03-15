using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;
using Vendas.Domain.Aggregates;

namespace Vendas.API.IntegrationEvents.EventHandling
{
  public class UsuarioAlteradoIntegrationEventHandler : IIntegrationEventHandler<UsuarioAlteradoIntegrationEvent>
  {
    private readonly ILogger<UsuarioAlteradoIntegrationEventHandler> _logger;
    private readonly ICompradoresRepository _compradoresRepository;

    public UsuarioAlteradoIntegrationEventHandler(ILogger<UsuarioAlteradoIntegrationEventHandler> logger, ICompradoresRepository compradoresRepository)
    {
      _logger = logger;
      _compradoresRepository = compradoresRepository;
    }

    public async Task Handle(UsuarioAlteradoIntegrationEvent @event)
    {
      _logger.LogInformation("----- Handling integration event: {IntegrationEventId} - ({@IntegrationEvent})", @event.Id, @event);

      var comprador = await _compradoresRepository.GetAsync(@event.UserId);

      if (comprador is not null)
      {
        comprador.Atualizar(
          nome: @event.Nome,
          email: @event.Email,
          fotoUrl: @event.FotoUrl
        );

        await _compradoresRepository.UpdateAsync(comprador);
      }
    }
  }
}