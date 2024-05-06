using Common.WebAPI.Notifications;
using Common.WebAPI.PostgreSql;
using MediatR;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.Shared.Pipeline
{
  public class DispatchDomainEventsResultNotificationPipeline<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
    where TResponse : ResultNotifications
  {
    private readonly ILogger<DispatchDomainEventsResultNotificationPipeline<TRequest, TResponse>> _logger;
    private readonly IMediator _mediator;
    private readonly IUnitOfWork _unitOfWork;
    private readonly INotificationsContext _notificationsContext;

    public DispatchDomainEventsResultNotificationPipeline(ILogger<DispatchDomainEventsResultNotificationPipeline<TRequest, TResponse>> logger, IMediator mediator, IUnitOfWork unitOfWork, INotificationsContext notificationsContext)
    {
      _logger = logger;
      _mediator = mediator;
      _unitOfWork = unitOfWork;
      _notificationsContext = notificationsContext;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
      cancellationToken.ThrowIfCancellationRequested();

      var response = await next();

      var entities = _unitOfWork.GetEntitiesPersistenceContext();

      foreach (var entity in entities)
      {
        _logger.LogInformation("----- Dispatch entity domain events result notifications {entityTypeName}", entity.GetType().Name);

        if (entity.HasDomainEvents)
        {
          var domainEvents = entity.DomainEvents.ToList();

          entity.ClearDomainEvents();

          foreach (var domainEvent in domainEvents)
          {
            if (_notificationsContext.HasErrors)
              return (TResponse)_notificationsContext.Notifications;

            _logger.LogInformation("----- Dispatch domain event result notifications {domainEvent}", domainEvent);

            await _mediator.Publish(domainEvent, cancellationToken);
          }
        }
      }

      return response;
    }
  }
}
