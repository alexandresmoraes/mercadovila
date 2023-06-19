using Catalogo.API.Data;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

namespace Catalogo.API.Controllers
{
  [Route("api/catalogo")]
  [ApiController]
  public class CatalogoController : ControllerBase
  {
    private readonly ProdutoService _produtoService;

    public CatalogoController(ProdutoService produtoService)
    {
      _produtoService = produtoService;
    }

    // GET: api/<CatalogoController>
    [HttpGet]
    public async Task<IEnumerable<Produto>> GetAsync()
    {
      return await _produtoService.Collection.AsQueryable().ToListAsync();
    }

    // GET api/<CatalogoController>/5
    [HttpGet("{id}")]
    public Produto? Get(string id)
    {
      return _produtoService.Collection
        .Find(Builders<Produto>.Filter.Eq("_id", ObjectId.Parse(id)))
        .SingleOrDefault();
    }

    // POST api/<CatalogoController>
    [HttpPost]
    public string Post([FromBody] Produto source)
    {
      _produtoService.Collection.InsertOne(source);
      return source.Id;
    }


    // DELETE api/<CatalogoController>/5
    [HttpDelete("{id}")]
    public void Delete(string id)
    {
      var filter = Builders<Produto>.Filter.Eq("_id", id);
      _produtoService.Collection.FindOneAndDelete(filter);
    }
  }
}
