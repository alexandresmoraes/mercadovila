using Microsoft.EntityFrameworkCore;
using Vendas.Domain.Aggregates;
using Vendas.Infra.Data;

namespace Vendas.Infra.Repositories
{
  public class VendaRepository : IVendaRepository
  {
    private readonly ApplicationDbContext _context;

    public VendaRepository(ApplicationDbContext context)
    {
      _context = context;
    }

    public async Task CreateAsync(Venda venda)
    {
      await _context.AddAsync(venda);
    }

    public async Task<Venda?> GetAsync(long id)
    {
      var venda = await _context.Vendas.FirstOrDefaultAsync(_ => _.Id == id);

      return venda;
    }
  }
}
