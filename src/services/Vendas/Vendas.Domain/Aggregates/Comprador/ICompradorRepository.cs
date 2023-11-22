namespace Vendas.Domain.Aggregates
{
  public interface ICompradorRepository
  {
    Task AddAsync(Comprador comprador);
    Task<Comprador?> GetAsync(string userId);
  }
}