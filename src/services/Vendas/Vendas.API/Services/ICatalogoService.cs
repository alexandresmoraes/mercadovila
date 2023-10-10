using Vendas.API.Models;

namespace Vendas.API.Services
{
  public interface ICatalogoService
  {
    Task<CarrinhoUsuarioResponseDto?> GetCarrinhoPorUsuario(string userId);
  }
}