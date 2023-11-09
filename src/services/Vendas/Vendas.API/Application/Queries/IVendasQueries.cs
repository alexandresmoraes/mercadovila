namespace Vendas.API.Application.Queries
{
  public interface IVendasQueries
  {
    Task<VendaDetalhe?> GetVendaAsync(long vendaId, CancellationToken cancellationToken = default);

    Task<IEnumerable<Venda>> GetVendasPorUsuarioAsync(VendaQuery vendaQuery, string userId, CancellationToken cancellationToken = default);

    Task<IEnumerable<Venda>> GetVendasAsync(VendaQuery vendaQuery, CancellationToken cancellationToken = default);
  }
}