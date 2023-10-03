﻿using Microsoft.EntityFrameworkCore;
using Vendas.Domain.Aggregates;
using Vendas.Infra.Data;

namespace Vendas.Infra.Repositories
{
  public class CompradorRepository : ICompradorRepository
  {
    private readonly ApplicationDbContext _context;

    public CompradorRepository(ApplicationDbContext context)
    {
      _context = context;
    }

    public async Task CreateAsync(Comprador comprador)
    {
      await _context.AddAsync(comprador);
    }

    public async Task<Comprador?> GetAsync(string userId)
    {
      var comprador = await _context.Compradores.FirstOrDefaultAsync(_ => _.UserId == userId);

      return comprador;
    }
  }
}