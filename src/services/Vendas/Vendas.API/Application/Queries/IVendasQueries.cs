using Common.WebAPI.Results;

namespace Vendas.API.Application.Queries
{
  public interface IVendasQueries
  {
    Task<VendaDetalheDto?> GetVendaAsync(long vendaId, CancellationToken cancellationToken = default);

    Task<PagedResult<VendaDto>> GetVendasPorUsuarioAsync(VendaQuery vendaQuery, string userId, CancellationToken cancellationToken = default);

    Task<PagedResult<VendaDto>> GetVendasAsync(VendaQuery vendaQuery, CancellationToken cancellationToken = default);
  }
}