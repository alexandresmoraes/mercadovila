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
    private readonly FavoritoItemRepository _favoritosRepository;

    public FavoritosController(FavoritoItemRepository favoritosRepository)
    {
      _favoritosRepository = favoritosRepository;
    }

    // GET: api/favoritos
    [HttpGet]
    public async Task<IEnumerable<FavoritoItem>> GetAsync()
    {
      return await _favoritosRepository.Collection.AsQueryable().ToListAsync();
    }

    // GET api/favoritos/5
    [HttpGet("{id}")]
    public FavoritoItem? Get(string id)
    {
      return _favoritosRepository.Collection
        .Find(Builders<FavoritoItem>.Filter.Eq("_id", id))
        .SingleOrDefault();
    }

    // POST api/favoritos
    [HttpPost]
    public string Post([FromBody] FavoritoItem source)
    {
      _favoritosRepository.Collection.InsertOne(source);
      return source.UserId;
    }

    // DELETE api/favoritos/5
    [HttpDelete("{id}")]
    public void Delete(string id)
    {
      var filter = Builders<FavoritoItem>.Filter.Eq("_id", id);
      _favoritosRepository.Collection.FindOneAndDelete(filter);
    }
  }
}
