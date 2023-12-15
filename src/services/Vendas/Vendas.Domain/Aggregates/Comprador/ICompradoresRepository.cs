namespace Vendas.Domain.Aggregates
{
  public interface ICompradoresRepository
  {
    Task AddAsync(Comprador comprador);
    Task<Comprador?> GetAsync(string userId);
  }
}