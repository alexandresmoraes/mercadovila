using Common.WebAPI.Results;
using Common.WebAPI.Utils;
using FluentValidation;
using FluentValidation.Results;
using MediatR;
using Microsoft.Extensions.Logging;

namespace Common.WebAPI.Shared.Pipeline
{
  public class ValidatorBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
    where TResponse : Result, new()
  {
    private readonly ILogger<ValidatorBehavior<TRequest, TResponse>> _logger;
    private readonly IEnumerable<IValidator<TRequest>> _validators;

    public ValidatorBehavior(IEnumerable<IValidator<TRequest>> validators, ILogger<ValidatorBehavior<TRequest, TResponse>> logger)
    {
      _validators = validators;
      _logger = logger;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
      var typeName = request.GetGenericTypeName();

      _logger.LogInformation("----- Validating command {CommandType}", typeName);

      var errors = _validators
          .Select(v => v.Validate(request))
          .SelectMany(result => result.Errors)
          .Where(error => error != null)
          .ToList();

      if (errors.Any())
      {
        _logger.LogWarning("Validation errors - {CommandType} - Command: {@Command} - Errors: {@ValidationErrors}", typeName, request, errors);

        return Errors(errors);
      }

      _logger.LogInformation("----- Validated command {CommandType}", typeName);

      return await next();
    }

    private TResponse Errors(IEnumerable<ValidationFailure> errors)
    {
      var response = new TResponse();

      foreach (var error in errors)
        response.AddError(error.ErrorCode, error.PropertyName, error.ErrorMessage);

      return response;
    }
  }
}