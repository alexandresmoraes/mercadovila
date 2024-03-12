using Compras.Domain.Aggregates;
using Compras.Infra.Data;
using Microsoft.EntityFrameworkCore;

namespace Compras.Infra.Repositories
{
  public class ComprasRepository : IComprasRepository
  {
    private readonly ApplicationDbContext _context;

    public ComprasRepository(ApplicationDbContext context)
    {
      _context = context;
    }

    public async Task AddAsync(Compra compra)
    {
      await _context.Compras.AddAsync(compra);
      await _context.SaveChangesAsync();
    }

    public async Task<Compra?> GetAsync(long compraId)
    {
      var compra = await _context
        .Compras
        .FirstOrDefaultAsync(c => c.Id == compraId)
      ?? _context.Compras
        .Local
        .FirstOrDefault(c => c.Id == compraId);

      if (compra is not null)
      {
        await _context
          .Entry(compra)
          .Collection(i => i.CompraItens)
          .LoadAsync();
      }

      return compra;
    }
  }
}