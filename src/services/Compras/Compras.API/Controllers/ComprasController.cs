using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Compras.API.Application.Commands;
using Compras.API.Application.Queries;
using Compras.API.Application.Responses;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Compras.API.Controllers
{
  [Route("api/compras")]
  [ApiController]
  [Authorize]
  public class ComprasController : ControllerBase
  {
    private readonly IMediator _mediator;
    private readonly IAuthService _authService;
    private readonly IComprasQueries _comprasQueries;

    public ComprasController(IMediator mediator, IAuthService authService, IComprasQueries comprasQueries)
    {
      _mediator = mediator;
      _authService = authService;
      _comprasQueries = comprasQueries;
    }

    /// <summary>
    /// Cria uma nova compra
    /// </summary>
    // POST api/compras
    [HttpPost]
    [ProducesResponseType(typeof(CriarCompraCommandResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<CriarCompraCommandResponse>> PostAsync([FromBody] CriarCompraCommand request, CancellationToken cancellationToken = default)
    {
      request.UserId = _authService.GetUserId();
      request.UserEmail = _authService.GetUserEmail();

      return await _mediator.Send(request, cancellationToken);
    }

    /// <summary>
    /// Retorna as compras paginadas
    /// </summary>
    // GET api/compras
    [Authorize("Admin")]
    [HttpGet]
    [ProducesResponseType(typeof(PagedResult<CompraDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<CompraDto>>> GetVendasAsync([FromQuery] CompraQuery compraQuery, CancellationToken cancellationToken = default)
      => Result.Ok(await _comprasQueries.GetComprasAsync(compraQuery, cancellationToken));
  }
}