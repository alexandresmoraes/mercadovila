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
  [Route("api/vendas")]
  [ApiController]
  [Authorize]
  public class VendasController : ControllerBase
  {
    private readonly IMediator _mediator;
    private readonly IAuthService _authService;
    private readonly IVendasQueries _vendasQueries;

    public VendasController(IMediator mediator, IAuthService authService, IVendasQueries vendasQueries)
    {
      _mediator = mediator;
      _authService = authService;
      _vendasQueries = vendasQueries;
    }

    /// <summary>
    /// Cria uma nova venda com os itens do carrinho
    /// </summary>
    // POST api/vendas
    [HttpPost]
    [ProducesResponseType(typeof(CriarVendaCommandResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<CriarVendaCommandResponse>> PostAsync([FromBody] CriarVendaCommand request, CancellationToken cancellationToken = default)
    {
      request.UserId = _authService.GetUserId();

      return await _mediator.Send(request, cancellationToken);
    }

    /// <summary>
    /// Retorna as vendas paginadas por usuário que está logado
    /// </summary>
    // GET api/vendas
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<Venda>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<IEnumerable<Venda>>> GetVendasPorUsuarioAsync(CancellationToken cancellationToken = default)
    {
      var userId = _authService.GetUserId();

      return Result.Ok(await _vendasQueries.GetVendasPorUsuarioAsync(userId));
    }
  }
}