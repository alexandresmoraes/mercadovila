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

      return Result.Ok(await _pagamentosQueries.GetPagamentoPendentes(userId, cancellationToken));
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
      => Result.Ok(await _pagamentosQueries.GetPagamentoPendentes(userId, cancellationToken));

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

    /// <summary>
    /// Retorna todos os pagamentos
    /// </summary>
    // GET api/pagamentos
    [HttpGet]
    [Authorize("Admin")]
    [ProducesResponseType(typeof(PagamentosDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<PagamentosDto>>> GetPagamentos([FromQuery] PagamentosQuery query, CancellationToken cancellationToken = default)
      => Result.Ok(await _pagamentosQueries.GetPagamentos(query, cancellationToken));

    /// <summary>
    /// Retorna meus os pagamentos
    /// </summary>
    // GET api/pagamentos/meus-pagamentos
    [HttpGet("meus-pagamentos")]
    [Authorize]
    [ProducesResponseType(typeof(PagamentosDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<PagamentosDto>>> GetMeusPagamentos([FromQuery] MeusPagamentosQuery query, CancellationToken cancellationToken = default)
    {
      query.userId = _authService.GetUserId();
      return Result.Ok(await _pagamentosQueries.GetMeusPagamentos(query, cancellationToken));
    }

    /// <summary>
    /// Realiza o cancelamento de um pagamento
    /// </summary>
    // PUT api/pagamentos/cancelar/{pagamentoId}
    [HttpPut("cancelar/{pagamentoId:long}")]
    [Authorize("Admin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> CancelarAsync([FromRoute] long pagamentoId, CancellationToken cancellationToken = default)
      => await _mediator.Send(new CancelarPagamentoCommand(pagamentoId), cancellationToken);
  }
}