using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Repositories;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Catalogo.API.Controllers
{
  [Route("api/carrinho")]
  [ApiController]
  public class CarrinhoController : ControllerBase
  {
    private readonly CarrinhoItemRepository _carrinhoRepository;
    private readonly IAuthService _authService;

    public CarrinhoController(CarrinhoItemRepository carrinhoRepository, IAuthService authService)
    {
      _carrinhoRepository = carrinhoRepository;
      _authService = authService;
    }

    /// <summary>
    /// Adiciona um produto no carrinho
    /// </summary>
    // POST api/carrinho/{produtoId}/{quantidade}
    [HttpPost("{produtoId}/{quantidade}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> PostAsync([FromRoute] string produtoId, [FromRoute] int quantidade)
    {
      var userId = _authService.GetUserId();

      await _carrinhoRepository.CreateAsync(userId, produtoId, quantidade);

      return Result.Ok();
    }

    /// <summary>
    /// Remove um produto do carrinho
    /// </summary>
    // DELETE api/carrinho/{produtoId}
    [HttpDelete("{produtoId}")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> DeleteAsync([FromRoute] string produtoId, [FromRoute] int quantidade)
    {
      var userId = _authService.GetUserId();

      await _carrinhoRepository.DeleteAsync(userId, produtoId, quantidade);

      return Result.Ok();
    }

    /// <summary>
    /// Retorna o carrinho do usuário
    /// </summary>
    // GET api/carrinho
    [HttpGet]
    [ProducesResponseType(typeof(CarrinhoDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<CarrinhoDto>> GetCarrinhoPorUsuarioAsync()
    {
      var userId = _authService.GetUserId();

      return Result.Ok(await _carrinhoRepository.GetCarrinhoPorUsuarioAsync(userId));
    }
  }
}