namespace Vendas.API.Application.Queries
{
  public class VendasQueries : IVendasQueries
  {
    // TODO: implementar

    public Task<VendaDetalhe> GetVendaAsync(int id)
    {
      throw new NotImplementedException();
    }

    public Task<IEnumerable<Venda>> GetVendasPorUsuarioAsync(string userId)
    {
      throw new NotImplementedException();
    }
  }
}
