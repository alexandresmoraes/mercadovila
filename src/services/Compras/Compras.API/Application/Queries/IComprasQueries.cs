using Common.WebAPI.Results;

namespace Compras.API.Application.Queries
{
  public interface IComprasQueries
  {
    Task<PagedResult<CompraDto>> GetComprasAsync(CompraQuery compraQuery, CancellationToken cancellationToken = default);
  }
}