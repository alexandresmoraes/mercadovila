namespace Vendas.Domain.Aggregates
{
  public interface IVendaRepository
  {
    Task CreateAsync(Venda venda);
    Task<Venda?> GetAsync(long id);
  }
}
