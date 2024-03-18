using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using MediatR;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public class CancelarPagamentoCommandHandler : IRequestHandler<CancelarPagamentoCommand, Result>
  {
    private readonly ILogger<CancelarPagamentoCommandHandler> _logger;
    private readonly IPagamentosRepository _pagamentosRepository;
    private readonly IAuthService _authService;

    public CancelarPagamentoCommandHandler(ILogger<CancelarPagamentoCommandHandler> logger, IPagamentosRepository pagamentosRepository, IAuthService authService)
    {
      _logger = logger;
      _pagamentosRepository = pagamentosRepository;
      _authService = authService;
    }

    public async Task<Result> Handle(CancelarPagamentoCommand request, CancellationToken cancellationToken)
    {
      _logger.LogTrace("Pagamento: {PagamentoId} cancelar.", request.PagamentoId);

      var pagamento = await _pagamentosRepository.GetAsync(request.PagamentoId);

      if (pagamento is null) return Result.NotFound();

      if (pagamento.Status != EnumStatusPagamento.Ativo)
        return Result.Fail($"Pagamento #{request.PagamentoId} não encontra-se Ativo.");

      pagamento.Cancelar(_authService.GetUserId(), _authService.GetUserName());

      return Result.Ok();
    }
  }
}