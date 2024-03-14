namespace Vendas.Domain.Aggregates
{
  public interface IVendasRepository
  {
    Task AddAsync(Venda venda);
    Task<Venda?> GetAsync(long vendaId);
  }
}