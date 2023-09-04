using Catalogo.API.Data.Repositories;
using Microsoft.AspNetCore.Mvc;

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
  }
}
