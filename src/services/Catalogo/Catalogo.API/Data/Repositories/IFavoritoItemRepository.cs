using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Queries;
using Common.WebAPI.Results;

namespace Catalogo.API.Data.Repositories
{
  public interface IFavoritoItemRepository
  {
    Task AdicionarAsync(string userId, string produtoId);
    Task<bool> RemoverAsync(string userId, string produtoId);
    Task<PagedResult<FavoritoItemDto>> GetFavoritosAsync(FavoritoItemQuery query, string userId);

    Task<bool> ExisteFavoritoPorUserId(string userId, string produtoId);
  }
}