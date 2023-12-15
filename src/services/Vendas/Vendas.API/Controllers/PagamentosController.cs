using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Vendas.API.Application.Commands;
using Vendas.API.Application.Queries;
using Vendas.API.Application.Responses;

namespace Vendas.API.Controllers
{
  [Route("api/pagamentos")]
  [ApiController]
  public class PagamentosController : ControllerBase
  {
    private readonly IAuthService _authService;
    private readonly IPagamentosQueries _pagamentosQueries;
    private readonly IMediator _mediator;

    public PagamentosController(IAuthService authService, IPagamentosQueries pagamentosQueries, IMediator mediator)
    {
      _authService = authService;
      _pagamentosQueries = pagamentosQueries;
      _mediator = mediator;
    }

    /// <summary>
    /// Retorna vendas que estão pendente de pagamento e o total devedor para o usuário logado
    /// </summary>
    // GET api/pagamentos/me
    [HttpGet("me")]
    [ProducesResponseType(typeof(PagamentoDetalheDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagamentoDetalheDto>> GetVendasPorUsuarioLogadoAsync(CancellationToken cancellationToken = default)
    {
      var userId = _authService.GetUserId();

      return Result.Ok(await _pagamentosQueries.GetPagamentoDetalheDto(userId, cancellationToken));
    }

    /// <summary>
    /// Retorna vendas que estão pendente de pagamento e o total devedor por id de usuário
    /// </summary>
    // GET api/pagamentos/{userId}
    [HttpGet("{userId}")]
    [Authorize("Admin")]
    [ProducesResponseType(typeof(PagamentoDetalheDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagamentoDetalheDto>> GetVendasPorUsuarioAsync([FromRoute] string userId, CancellationToken cancellationToken = default)
      => Result.Ok(await _pagamentosQueries.GetPagamentoDetalheDto(userId, cancellationToken));

    /// <summary>
    /// Realiza um pagamento para um usuário/comprador
    /// </summary>
    // POST api/pagamentos
    [HttpPost]
    [Authorize("Admin")]
    [ProducesResponseType(typeof(RealizarPagamentoCommandResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<RealizarPagamentoCommandResponse>> PostAsync([FromBody] RealizarPagamentoCommand request, CancellationToken cancellationToken = default)
      => await _mediator.Send(request, cancellationToken);
  }
}