using Vendas.Domain.Aggregates;
using Vendas.Infra.Data;

namespace Vendas.Infra.Repositories
{
  public class PagamentosRepository : IPagamentosRepository
  {
    private readonly ApplicationDbContext _context;

    public PagamentosRepository(ApplicationDbContext context)
    {
      _context = context;
    }

    public async Task AddAsync(Pagamento pagamento)
    {
      await _context.Pagamentos.AddAsync(pagamento);
      await _context.SaveChangesAsync();
    }
  }
}