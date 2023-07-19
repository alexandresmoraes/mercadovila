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
    private readonly CarrinhoRepository _carrinhoRepository;

    public CarrinhoController(CarrinhoRepository carrinhoRepository)
    {
      _carrinhoRepository = carrinhoRepository;
    }

    // GET: api/carrinho/{userId}
    [HttpGet("{userId}")]
    public async Task<Result<Carrinho>> GetAsync([FromRoute] string userId)
    {
      var carrinho = await _carrinhoRepository.Collection
        .Find(Builders<Carrinho>.Filter.Eq(e => e.UserId, userId))
        .SingleOrDefaultAsync();

      if (carrinho is null)
        return Result.NotFound<Carrinho>();

      return Result.Ok(carrinho);
    }

    // POST api/carrinho
    [HttpPost]
    public string Post([FromBody] Carrinho source)
    {
      _carrinhoRepository.Collection.InsertOne(source);
      return source.UserId;
    }

    // DELETE api/carrinho/5
    [HttpDelete("{id}")]
    public void Delete(string id)
    {
      var filter = Builders<Carrinho>.Filter.Eq("_id", id);
      _carrinhoRepository.Collection.FindOneAndDelete(filter);
    }
  }
}
