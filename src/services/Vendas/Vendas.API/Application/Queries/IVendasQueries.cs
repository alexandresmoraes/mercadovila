namespace Vendas.API.Application.Queries
{
  public interface IVendasQueries
  {
    Task<VendaDetalhe> GetVendaAsync(int id);

    Task<IEnumerable<Venda>> GetVendasPorUsuarioAsync(string userId);
  }
}
