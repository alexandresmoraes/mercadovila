using Common.WebAPI.PostgreSql;
using Common.WebAPI.Results;
using MediatR;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.Shared.Pipeline
{
  public class DispatchDomainEventsResultPipeline<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
    where TResponse : Result
  {
    private readonly ILogger<DispatchDomainEventsResultPipeline<TRequest, TResponse>> _logger;
    private readonly IMediator _mediator;
    private readonly IUnitOfWork _unitOfWork;

    public DispatchDomainEventsResultPipeline(ILogger<DispatchDomainEventsResultPipeline<TRequest, TResponse>> logger, IMediator mediator, IUnitOfWork unitOfWork)
    {
      _logger = logger;
      _mediator = mediator;
      _unitOfWork = unitOfWork;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
      cancellationToken.ThrowIfCancellationRequested();

      var response = await next();

      var entities = _unitOfWork.GetEntitiesPersistenceContext();

      foreach (var entity in entities)
      {
        _logger.LogInformation("----- Dispatch entity domain events result: {entityTypeName}", entity.GetType().Name);

        if (entity.HasDomainEvents)
        {
          var domainEvents = entity.DomainEvents.ToList();

          entity.ClearDomainEvents();

          foreach (var domainEvent in domainEvents)
          {
            if (response is Result result && !result.IsValid)
              return response;

            _logger.LogInformation("----- Dispatch domain event result {domainEvent}", domainEvent);

            await _mediator.Publish(domainEvent, cancellationToken);
          }
        }
      }

      return response;
    }
  }
}
