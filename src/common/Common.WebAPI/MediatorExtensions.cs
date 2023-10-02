using Common.WebAPI.Shared;
using MediatR;

namespace Common.WebAPI
{
  public static class MediatorExtensions
  {
    public static async Task DispatchDomainEventsAsync(this IMediator mediator, Entity entity)
    {
      if (entity.DomainEvents is null || !entity.DomainEvents.Any())
        return;

      var domainEvents = entity.DomainEvents.ToList();

      entity.ClearDomainEvents();

      foreach (var domainEvent in domainEvents)
        await mediator.Publish(domainEvent);
    }
  }
}
