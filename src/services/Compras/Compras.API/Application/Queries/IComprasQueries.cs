using Common.WebAPI.Results;

namespace Compras.API.Application.Queries
{
  public interface IComprasQueries
  {
    Task<CompraDetalheDto?> GetCompraAsync(long compraId, CancellationToken cancellationToken = default);
    Task<PagedResult<CompraDto>> GetComprasAsync(CompraQuery compraQuery, CancellationToken cancellationToken = default);
  }
}