using Catalogo.API.Data.Dto;
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
  }
}