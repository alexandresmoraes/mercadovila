using Catalogo.API.Data.Entities;

namespace Catalogo.API.Data.Repositories
{
  public interface IRatingItemRepository
  {
    Task AdicionarAsync(RatingItem rating);
    Task<RatingItem?> GetRatingPorVendaEProduto(long vendaId, string produtoId);
    Task<short> RatingPorVendaEProduto(long vendaId, string produtoId);
    Task AtualizarAsync(RatingItem rating);
  }
}
