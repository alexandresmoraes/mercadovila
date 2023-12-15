namespace Vendas.Domain.Aggregates
{
  public interface IPagamentosRepository
  {
    Task AddAsync(Pagamento pagamento);
  }
}