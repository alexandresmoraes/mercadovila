using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Repositories;
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

    // GET: api/carrinho
    [HttpGet]
    public async Task<IEnumerable<Carrinho>> GetAsync()
    {
      return await _carrinhoRepository.Collection.AsQueryable().ToListAsync();
    }

    // GET api/carrinho/5
    [HttpGet("{id}")]
    public Carrinho? Get(string id)
    {
      return _carrinhoRepository.Collection
        .Find(Builders<Carrinho>.Filter.Eq("_id", id))
        .SingleOrDefault();
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
