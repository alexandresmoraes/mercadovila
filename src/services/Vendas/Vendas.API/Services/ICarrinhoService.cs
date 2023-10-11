using Vendas.API.Models;

namespace Vendas.API.Services
{
  public interface ICarrinhoService
  {
    Task<CarrinhoUsuarioResponseDto?> GetCarrinhoPorUsuario(string userId);
  }
}