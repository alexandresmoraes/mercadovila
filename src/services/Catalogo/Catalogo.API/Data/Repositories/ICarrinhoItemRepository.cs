using Catalogo.API.Data.Dto;

namespace Catalogo.API.Data.Repositories
{
  public interface ICarrinhoItemRepository
  {
    Task CreateAsync(string userId, string produtoId, int quantidade);
    Task<bool> DeleteAsync(string userId, string produtoId, int quantidade);
    Task<CarrinhoDto> GetCarrinhoPorUsuarioAsync(string userId);
  }
}
