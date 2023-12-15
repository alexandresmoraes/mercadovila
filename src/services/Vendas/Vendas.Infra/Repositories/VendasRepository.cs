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

    public async Task<Venda?> GetAsync(long id)
    {
      var venda = await _context.Vendas.FirstOrDefaultAsync(_ => _.Id == id);

      return venda;
    }   
  }
}
