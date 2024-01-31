using Common.WebAPI.Results;

namespace Vendas.API.Application.Queries
{
  public interface IPagamentosQueries
  {
    Task<PagamentoDetalheDto> GetPagamentoDetalhe(string userId, CancellationToken cancellationToken = default);
    Task<PagedResult<PagamentosDto>> GetPagamentos(PagamentosQuery query, CancellationToken cancellationToken = default);
  }
}