using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Vendas.API.Application.Commands;
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

    public VendasController(IMediator mediator, IAuthService authService)
    {
      _mediator = mediator;
      _authService = authService;
    }

    /// <summary>
    /// Cria uma nova venda com os itens do carrinho
    /// </summary>
    // POST api/vendas
    [HttpPost]
    [ProducesResponseType(typeof(CriarVendaCommandResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<CriarVendaCommandResponse>> PostAsync([FromBody] CriarVendaCommand request, CancellationToken cancellationToken)
    {
      var userId = _authService.GetUserId();

      request.UserId = userId;

      return await _mediator.Send(request, cancellationToken);
    }
  }
}