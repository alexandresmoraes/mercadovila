using Catalogo.API.Data.Repositories;
using Microsoft.AspNetCore.Mvc;

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
  }
}