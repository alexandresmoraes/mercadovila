using Common.WebAPI.Notifications;
using Common.WebAPI.PostgreSql;
using MediatR;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.Shared.Pipeline
{
  public class DispatchDomainEventsPipeline<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
  {
    private readonly ILogger<DispatchDomainEventsPipeline<TRequest, TResponse>> _logger;
    private readonly IMediator _mediator;
    private readonly IUnitOfWork _unitOfWork;
    private readonly INotificationsContext _notificationsContext;

    public DispatchDomainEventsPipeline(ILogger<DispatchDomainEventsPipeline<TRequest, TResponse>> logger, IMediator mediator, IUnitOfWork unitOfWork, INotificationsContext notificationsContext)
    {
      _logger = logger;
      _mediator = mediator;
      _unitOfWork = unitOfWork;
      _notificationsContext = notificationsContext;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
      cancellationToken.ThrowIfCancellationRequested();

      if (typeof(TResponse) == typeof(ResultNotifications))
      {
        var response = await next();

        var entities = _unitOfWork.GetEntitiesPersistenceContext()!;

        foreach (var entity in entities)
        {
          _logger.LogInformation("Dispatch entity domain events {entityTypeName}", entity.GetType().Name);

          if (entity.HasDomainEvents)
          {
            var domainEvents = entity.DomainEvents!.ToList();

            entity.ClearDomainEvents();

            foreach (var domainEvent in domainEvents)
            {
              if (_notificationsContext.HasErrors)
                return (TResponse)(object)_notificationsContext.Notifications;

              _logger.LogInformation("Dispatch domain event {domainEvent}", domainEvent);

              await _mediator.Publish(domainEvent);
            }
          }
        }

        return response;
      }

      return await next();
    }
  }
}