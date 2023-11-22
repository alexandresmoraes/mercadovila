using Common.WebAPI.PostgreSql;
using Microsoft.EntityFrameworkCore;
using Vendas.Domain.Aggregates;
using Vendas.Infra.Data;

namespace Vendas.Infra.Repositories
{
  public class VendaRepository : IVendaRepository
  {
    private readonly ApplicationDbContext _context;
    private readonly IUnitOfWork _unitOfWork;

    public VendaRepository(ApplicationDbContext context, IUnitOfWork unitOfWork)
    {
      _context = context;
      _unitOfWork = unitOfWork;
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
