using Catalogo.API.Data.Dto;

namespace Catalogo.API.Data.Repositories
{
  public interface ICarrinhoItemRepository
  {
    Task AdicionarAsync(string userId, string produtoId, int quantidade);
    Task RemoverAsync(string userId, string produtoId, int quantidade);
    Task<CarrinhoDto> GetCarrinhoPorUsuarioAsync(string userId);
    Task<int> GetQuantidadeCarrinhoItem(string userId, string produtoId);
    Task RemoverCarrinhoPorUsuarioAsync(string userId);
  }
}