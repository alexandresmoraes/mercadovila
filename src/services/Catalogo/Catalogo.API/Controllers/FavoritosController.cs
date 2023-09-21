using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Queries;
using Catalogo.API.Data.Repositories;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Catalogo.API.Controllers
{
  /// <summary>
  /// Adiciona, remove e lista os favoritos
  /// </summary>
  [Route("api/favoritos")]
  [ApiController]
  [Authorize]
  public class FavoritosController : ControllerBase
  {
    private readonly FavoritoItemRepository _favoritosRepository;
    private readonly IAuthService _authService;

    public FavoritosController(FavoritoItemRepository favoritosRepository, IAuthService authService)
    {
      _favoritosRepository = favoritosRepository;
      _authService = authService;
    }

    /// <summary>
    /// Adiciona um produto no favoritos
    /// </summary>
    // POST api/favoritos/{produtoId}
    [HttpPost("{produtoId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> PostAsync([FromRoute] string produtoId)
    {
      var userId = _authService.GetUserId();

      var existeFavorito = await _favoritosRepository.ExisteFavoritoPorUserId(userId, produtoId);

      if (!existeFavorito)
        await _favoritosRepository.AdicionarAsync(userId, produtoId);

      return Result.Ok();
    }

    /// <summary>
    /// Remove um produto do favoritos
    /// </summary>
    // DELETE api/favoritos/{produtoId}
    [HttpDelete("{produtoId}")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> DeleteAsync([FromRoute] string produtoId)
    {
      var userId = _authService.GetUserId();

      var existeFavorito = await _favoritosRepository.ExisteFavoritoPorUserId(userId, produtoId);
      if (existeFavorito)
        await _favoritosRepository.RemoverAsync(userId, produtoId);

      return Result.Ok();
    }

    /// <summary>
    /// Retorna os favoritos do usuário
    /// </summary>
    // GET api/favoritos
    [HttpGet]
    [ProducesResponseType(typeof(PagedResult<FavoritoItemDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<FavoritoItemDto>>> GetFavoritosAsync([FromQuery] FavoritoItemQuery query)
    {
      var userId = _authService.GetUserId();

      return Result.Ok(await _favoritosRepository.GetFavoritosAsync(query, userId));
    }
  }
}
