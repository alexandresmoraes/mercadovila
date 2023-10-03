namespace Vendas.Domain.Aggregates
{
  public interface ICompradorRepository
  {
    Task CreateAsync(Comprador comprador);
    Task<Comprador?> GetAsync(string userId);
  }
}