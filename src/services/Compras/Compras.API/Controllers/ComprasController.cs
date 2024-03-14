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
    private readonly IComprasQueries _comprasQueries;

    public ComprasController(IMediator mediator, IComprasQueries comprasQueries)
    {
      _mediator = mediator;
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
      => await _mediator.Send(request, cancellationToken);

    /// <summary>
    /// Retorna a compra por id
    /// </summary>
    // GET api/compras/{compraId}
    [HttpGet("{compraId:long}")]
    [ProducesResponseType(typeof(CompraDetalheDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<CompraDetalheDto>> GetVendaAsync([FromRoute] long compraId, CancellationToken cancellationToken = default)
    {
      var compra = await _comprasQueries.GetCompraAsync(compraId, cancellationToken);

      if (compra is null)
        return Result.NotFound<CompraDetalheDto>();

      return Result.Ok(compra!);
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