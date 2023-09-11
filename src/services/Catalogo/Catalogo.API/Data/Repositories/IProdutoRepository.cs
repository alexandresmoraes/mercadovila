﻿using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Queries;
using Common.WebAPI.Results;

namespace Catalogo.API.Data.Repositories
{
  public interface IProdutoRepository
  {
    Task CreateAsync(Produto produto);
    Task UpdateAsync(Produto produto);
    Task<Produto?> GetAsync(string id);
    Task<PagedResult<ProdutoDto>> GetProdutosAsync(ProdutoQuery produtoQuery);
    Task<bool> ExisteProdutoPorNome(string nome, string? id);
    Task<bool> ExisteProdutoPorCodigoBarras(string codigoBarras, string? id);

    Task<PagedResult<CatalogoDto>> GetProdutosNovosAsync(CatalogoQuery query);
    Task<PagedResult<CatalogoDto>> GetProdutosMaisVendidosAsync(CatalogoQuery query);
    Task<PagedResult<CatalogoDto>> GetProdutosFavoritosAsync(string userId, CatalogoQuery query);
    Task<PagedResult<CatalogoDto>> GetProdutosUltimosVendidosAsync(CatalogoQuery query);
  }
}