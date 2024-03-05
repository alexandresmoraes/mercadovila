using Microsoft.EntityFrameworkCore;
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

    public async Task<Pagamento?> GetAsync(long pagamentoId)
    {
      var pagamento = await _context.Pagamentos
        .Include(p => p.Comprador)
        .FirstOrDefaultAsync(p => p.Id == pagamentoId);

      if (pagamento is null)
      {
        pagamento = _context
                    .Pagamentos
                    .Local
                    .FirstOrDefault(p => p.Id == pagamentoId);
      }

      if (pagamento is not null)
      {
        await _context.Entry(pagamento)
            .Collection(i => i.Vendas).LoadAsync();
      }

      return pagamento;
    }
  }
}