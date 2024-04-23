using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Repositories;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Catalogo.API.Controllers
{
  /// <summary>
  /// Verificar e adicionar rating em produtos
  /// </summary>
  [Authorize]
  [Route("api/rating")]
  [ApiController]
  public class RatingController : ControllerBase
  {
    private readonly RatingItemRepository _ratingItemRepository;
    private readonly ProdutoRepository _produtoRepository;

    public RatingController(RatingItemRepository ratingItemRepository, ProdutoRepository produtoRepository)
    {
      _ratingItemRepository = ratingItemRepository;
      _produtoRepository = produtoRepository;
    }

    /// <summary>
    /// Adiciona um rating no produto
    /// </summary>
    // POST api/rating/{vendaId}/{produtoId}/{rating}
    [HttpPost("{vendaId}/{produtoId}/{rating}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> PostAsync(
      [FromRoute] long vendaId,
      [FromRoute] string produtoId,
      [FromRoute] short rating)
    {
      var ratingItem = await _ratingItemRepository.GetRatingPorVendaEProduto(vendaId, produtoId);

      if (ratingItem is not null)
      {
        ratingItem.Rating = rating;
        await _ratingItemRepository.AtualizarAsync(ratingItem);
      }
      else
      {
        await _ratingItemRepository.AdicionarAsync(new RatingItem
        {
          VendaId = vendaId,
          ProdutoId = produtoId,
          Rating = rating
        });
      }

      await _produtoRepository.AtualizarRating(produtoId);

      return Result.Ok();
    }

    /// <summary>
    /// Retorna o rating do produto
    /// </summary>
    // GET api/rating/{vendaId}/{produtoId}    
    [HttpGet("{vendaId}/{produtoId}")]
    [ProducesResponseType(typeof(RatingItem), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<RatingItem>> GetAsync([FromRoute] long vendaId, [FromRoute] string produtoId)
    {
      var ratingItem = await _ratingItemRepository.GetRatingPorVendaEProduto(vendaId, produtoId) ?? new RatingItem
      {
        VendaId = vendaId,
        ProdutoId = produtoId,
        Rating = 0
      };

      return Result.Ok(ratingItem);
    }
  }
}