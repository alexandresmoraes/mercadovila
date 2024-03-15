namespace Vendas.Domain.Aggregates
{
  public interface ICompradoresRepository
  {
    Task AddAsync(Comprador comprador);
    Task UpdateAsync(Comprador comprador);
    Task<Comprador?> GetAsync(string userId);
  }
}