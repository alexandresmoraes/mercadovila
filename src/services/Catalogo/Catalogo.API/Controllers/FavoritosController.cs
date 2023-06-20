using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Repositories;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;

namespace Catalogo.API.Controllers
{
  [Route("api/favoritos")]
  [ApiController]
  public class FavoritosController : ControllerBase
  {
    private readonly FavoritosRepository _favoritosRepository;

    public FavoritosController(FavoritosRepository favoritosRepository)
    {
      _favoritosRepository = favoritosRepository;
    }

    // GET: api/favoritos
    [HttpGet]
    public async Task<IEnumerable<Favoritos>> GetAsync()
    {
      return await _favoritosRepository.Collection.AsQueryable().ToListAsync();
    }

    // GET api/favoritos/5
    [HttpGet("{id}")]
    public Favoritos? Get(string id)
    {
      return _favoritosRepository.Collection
        .Find(Builders<Favoritos>.Filter.Eq("_id", id))
        .SingleOrDefault();
    }

    // POST api/favoritos
    [HttpPost]
    public string Post([FromBody] Favoritos source)
    {
      _favoritosRepository.Collection.InsertOne(source);
      return source.UserId;
    }

    // DELETE api/favoritos/5
    [HttpDelete("{id}")]
    public void Delete(string id)
    {
      var filter = Builders<Favoritos>.Filter.Eq("_id", id);
      _favoritosRepository.Collection.FindOneAndDelete(filter);
    }
  }
}
