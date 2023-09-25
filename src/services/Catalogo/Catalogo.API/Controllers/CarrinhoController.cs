using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Repositories;
using Catalogo.API.Models;
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
    private readonly ProdutoRepository _produtoRepository;
    private readonly IAuthService _authService;

    public CarrinhoController(CarrinhoItemRepository carrinhoRepository, ProdutoRepository produtoRepository, IAuthService authService)
    {
      _carrinhoRepository = carrinhoRepository;
      _produtoRepository = produtoRepository;
      _authService = authService;
    }

    /// <summary>
    /// Adiciona um produto no carrinho
    /// </summary>
    // POST api/carrinho/{produtoId}/{quantidade}
    [HttpPost("{produtoId}/{quantidade}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> PostAsync([FromRoute] CarrinhoItemModel model)
    {
      var userId = _authService.GetUserId();

      if (!await _produtoRepository.ExisteProdutoPorId(model.produtoId))
        return Result.Fail("Produto não encontrado.");

      await _carrinhoRepository.AdicionarAsync(userId, model.produtoId, model.quantidade);

      return Result.Ok();
    }

    /// <summary>
    /// Remove um produto do carrinho
    /// </summary>
    // DELETE api/carrinho/{produtoId}/{quantidade}
    [HttpDelete("{produtoId}/{quantidade}")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> DeleteAsync([FromRoute] CarrinhoItemModel model)
    {
      var userId = _authService.GetUserId();

      if (!await _produtoRepository.ExisteProdutoPorId(model.produtoId))
        return Result.Fail("Produto não encontrado.");

      var quantidadeAtual = await _carrinhoRepository.GetQuantidadeCarrinhoItem(userId, model.produtoId);

      if (quantidadeAtual < model.quantidade)
        return Result.Fail("Quantidade do item é maior que a atual");

      await _carrinhoRepository.RemoverAsync(userId, model.produtoId, model.quantidade);

      return Result.Ok();
    }

    /// <summary>
    /// Retorna o carrinho do usuário
    /// </summary>
    // GET api/carrinho
    [HttpGet]
    [ProducesResponseType(typeof(CarrinhoDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<CarrinhoDto>> GetCarrinhoPorUsuarioAsync()
    {
      var userId = _authService.GetUserId();

      return Result.Ok(await _carrinhoRepository.GetCarrinhoPorUsuarioAsync(userId));
    }
  }
}