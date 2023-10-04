namespace Vendas.Domain.Aggregates
{
  public interface IVendaRepository
  {
    Task AddAsync(Venda venda);
    Task<Venda?> GetAsync(long id);
  }
}
