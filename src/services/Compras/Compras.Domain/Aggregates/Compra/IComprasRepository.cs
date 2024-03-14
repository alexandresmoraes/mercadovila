namespace Compras.Domain.Aggregates
{
  public interface IComprasRepository
  {
    Task AddAsync(Compra compra);
    Task<Compra?> GetAsync(long compraId);
  }
}
