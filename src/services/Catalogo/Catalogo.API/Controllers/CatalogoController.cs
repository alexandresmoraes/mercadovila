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
  /// Catalogo para listagem dos produtos de forma ordenada
  /// </summary>
  [Route("api/catalogo")]
  [Authorize]
  [ApiController]
  public class CatalogoController : ControllerBase
  {
    private readonly ProdutoRepository _produtoRepository;
    private readonly IAuthService _authService;

    public CatalogoController(ProdutoRepository produtoRepository, IAuthService authService)
    {
      _produtoRepository = produtoRepository;
      _authService = authService;
    }

    /// <summary>
    /// Retorna os produtos ordenados por data de criação desc
    /// </summary>
    // GET api/catalogo/novos
    [HttpGet("novos")]
    [ProducesResponseType(typeof(PagedResult<CatalogoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<CatalogoDto>>> GetProdutosNovosAsync([FromQuery] CatalogoQuery query)
      => Result.Ok(await _produtoRepository.GetProdutosNovosAsync(query));

    /// <summary>
    /// Retorna os produtos ordenados por quantidade vendida desc
    /// </summary>
    // GET api/catalogo/mais-vendidos
    [HttpGet("mais-vendidos")]
    [ProducesResponseType(typeof(PagedResult<CatalogoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<CatalogoDto>>> GetProdutosMaisVendidosAsync([FromQuery] CatalogoQuery query)
      => Result.Ok(await _produtoRepository.GetProdutosMaisVendidosAsync(query));

    /// <summary>
    /// Retorna os produtos ordenados data da última venda desc
    /// </summary>
    // GET api/catalogo/ultimos-vendidos
    [HttpGet("ultimos-vendidos")]
    [ProducesResponseType(typeof(PagedResult<CatalogoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<CatalogoDto>>> GetProdutosUltimosVendidosAsync([FromQuery] CatalogoQuery query)
      => Result.Ok(await _produtoRepository.GetProdutosUltimosVendidosAsync(query));

    /// <summary>
    /// Retorna os produtos favoritos
    /// </summary>
    // GET api/catalogo/favoritos
    [HttpGet("favoritos")]
    [ProducesResponseType(typeof(PagedResult<CatalogoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<CatalogoDto>>> GetProdutosFavoritosAsync([FromQuery] CatalogoQuery query)
    {
      var userId = _authService.GetUserId();

      return Result.Ok(await _produtoRepository.GetProdutosFavoritosAsync(userId, query));
    }

    /// <summary>
    /// Retorna todos os produtos ativos
    /// </summary>
    // GET api/catalogo/todos
    [HttpGet("todos")]
    [ProducesResponseType(typeof(PagedResult<CatalogoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<CatalogoDto>>> GetTodosProdutosAsync([FromQuery] CatalogoTodosQuery query)
    {
      return Result.Ok(await _produtoRepository.GetTodosProdutosAtivosAsync(query));
    }
  }
}