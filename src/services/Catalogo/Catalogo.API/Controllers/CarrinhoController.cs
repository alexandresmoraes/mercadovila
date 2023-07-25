using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Repositories;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;

namespace Catalogo.API.Controllers
{
  [Route("api/carrinho")]
  [ApiController]
  public class CarrinhoController : ControllerBase
  {
    private readonly CarrinhoItemRepository _carrinhoRepository;

    public CarrinhoController(CarrinhoItemRepository carrinhoRepository)
    {
      _carrinhoRepository = carrinhoRepository;
    }

    // GET: api/carrinho/{userId}
    [HttpGet("{userId}")]
    public async Task<Result<CarrinhoItem>> GetAsync([FromRoute] string userId)
    {
      var carrinho = await _carrinhoRepository.Collection
        .Find(Builders<CarrinhoItem>.Filter.Eq(e => e.UserId, userId))
        .SingleOrDefaultAsync();

      if (carrinho is null)
        return Result.NotFound<CarrinhoItem>();

      return Result.Ok(carrinho);
    }

    // POST api/carrinho
    [HttpPost]
    public Result<string> Post([FromBody] CarrinhoItem source)
    {
      _carrinhoRepository.Collection.InsertOne(source);
      return Result.Ok(source.UserId);
    }

    // DELETE api/carrinho/5
    [HttpDelete("{id}")]
    public Result Delete(string id)
    {
      var filter = Builders<CarrinhoItem>.Filter.Eq("_id", id);
      _carrinhoRepository.Collection.FindOneAndDelete(filter);

      return Result.Ok();
    }
  }
}
