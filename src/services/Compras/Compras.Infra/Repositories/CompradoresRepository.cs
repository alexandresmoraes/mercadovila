using Compras.Domain.Aggregates;
using Compras.Infra.Data;
using Microsoft.EntityFrameworkCore;

namespace Compras.Infra.Repositories
{
  public class CompradoresRepository : ICompradoresRepository
  {
    private readonly ApplicationDbContext _context;

    public CompradoresRepository(ApplicationDbContext context)
    {
      _context = context;
    }

    public async Task AddAsync(Comprador comprador)
    {
      await _context.Compradores.AddAsync(comprador);
      await _context.SaveChangesAsync();
    }

    public async Task<Comprador?> GetAsync(string userId)
    {
      var comprador = await _context.Compradores.FirstOrDefaultAsync(_ => _.UserId == userId);

      return comprador;
    }

    public async Task UpdateAsync(Comprador comprador)
    {
      _context.Compradores.Update(comprador);
      await _context.SaveChangesAsync();
    }
  }
}