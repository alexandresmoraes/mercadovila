using Microsoft.EntityFrameworkCore;
using Vendas.Domain.Aggregates;
using Vendas.Infra.Data;

namespace Vendas.Infra.Repositories
{
  public class VendasRepository : IVendasRepository
  {
    private readonly ApplicationDbContext _context;

    public VendasRepository(ApplicationDbContext context)
    {
      _context = context;
    }

    public async Task AddAsync(Venda venda)
    {
      await _context.Vendas.AddAsync(venda);
      await _context.SaveChangesAsync();
    }

    public async Task<Venda?> GetAsync(long vendaId)
    {
      var venda = await _context
        .Vendas
        .Include(v => v.Comprador)
        .FirstOrDefaultAsync(v => v.Id == vendaId)
      ?? _context.Vendas
          .Local
          .FirstOrDefault(p => p.Id == vendaId);

      if (venda is not null)
      {
        await _context
          .Entry(venda)
          .Collection(i => i.VendaItens)
          .LoadAsync();
      }


      return venda;
    }
  }
}
