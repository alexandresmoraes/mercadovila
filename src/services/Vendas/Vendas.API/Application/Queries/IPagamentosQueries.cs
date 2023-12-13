namespace Vendas.API.Application.Queries
{
  public interface IPagamentosQueries
  {
    Task<PagamentoDetalheDto> GetPagamentoDetalheDto(string userId, CancellationToken cancellationToken = default);
  }
}