namespace Vendas.Domain.Aggregates
{
  public interface IPagamentosRepository
  {
    Task AddAsync(Pagamento pagamento);
    Task<Pagamento?> GetAsync(long pagamentoId);
  }
}