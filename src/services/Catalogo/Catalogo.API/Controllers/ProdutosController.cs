using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Repositories;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;

namespace Catalogo.API.Controllers
{
  [Route("api/produtos")]
  [ApiController]
  public class ProdutosController : ControllerBase
  {
    private readonly ProdutoRepository _produtoRepository;

    public ProdutosController(ProdutoRepository produtoService)
    {
      _produtoRepository = produtoService;
    }

    // GET: api/catalogo
    [HttpGet]
    public async Task<IEnumerable<Produto>> GetAsync()
    {
      return await _produtoRepository.Collection.AsQueryable().ToListAsync();
    }

    // GET api/catalogo/5
    [HttpGet("{id}")]
    public Produto? Get(string id)
    {
      return _produtoRepository.Collection
        .Find(Builders<Produto>.Filter.Eq("_id", id))
        .SingleOrDefault();
    }

    // POST api/catalogo
    [HttpPost]
    public string Post([FromBody] Produto source)
    {
      _produtoRepository.Collection.InsertOne(source);
      return source.Id!;
    }

    // DELETE api/catalogo/5
    [HttpDelete("{id}")]
    public void Delete(string id)
    {
      var filter = Builders<Produto>.Filter.Eq("_id", id);
      _produtoRepository.Collection.FindOneAndDelete(filter);
    }
  }
}
