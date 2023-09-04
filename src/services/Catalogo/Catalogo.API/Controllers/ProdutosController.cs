using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Queries;
using Catalogo.API.Data.Repositories;
using Catalogo.API.Models;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Catalogo.API.Controllers
{
  [Route("api/produtos")]
  [Authorize("Admin")]
  [ApiController]
  public class ProdutosController : ControllerBase
  {
    private readonly ProdutoRepository _produtoRepository;

    public ProdutosController(ProdutoRepository produtoService)
    {
      _produtoRepository = produtoService;
    }

    /// <summary>
    /// Pega informações do produto para edição
    /// </summary>
    // GET api/catalogo/{id}
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(ProdutoModel), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<ProdutoModel>> GetAsync([FromRoute] string id)
    {
      var produto = await _produtoRepository.GetAsync(id);

      if (produto is null)
        Result.NotFound();

      return Result.Ok(new ProdutoModel
      {
        Id = produto!.Id,
        Nome = produto.Nome,
        Descricao = produto.Descricao,
        Preco = produto.Preco,
        UnidadeMedida = produto.UnidadeMedida,
        CodigoBarras = produto.CodigoBarras,
        EstoqueAlvo = produto.EstoqueAlvo,
        Estoque = produto.Estoque,
        IsAtivo = produto.IsAtivo
      });
    }

    /// <summary>
    /// Retorna produtos paginados
    /// </summary>
    // GET api/catalogo
    [HttpGet]
    [ProducesResponseType(typeof(PagedResult<ProdutoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<ProdutoDto>>> GetProdutosAsync([FromQuery] ProdutoQuery query)
      => Result.Ok(await _produtoRepository.GetProdutosAsync(query));

    /// <summary>
    /// Criação de novos produtos
    /// </summary>
    // POST api/catalogo    
    [HttpPost]
    [ProducesResponseType(typeof(ProdutoModel), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<ProdutoResponseModel>> PostAsync([FromBody] ProdutoModel produtoModel)
    {
      var isExist = await _produtoRepository.ExisteProdutoPorNome(produtoModel.Nome!, null);

      if (isExist)
        return Result.Fail<ProdutoResponseModel>("Produto já existente com o mesmo nome.");

      var produto = new Produto
      {
        Nome = produtoModel.Nome!,
        Descricao = produtoModel.Descricao!,
        Preco = produtoModel.Preco!,
        UnidadeMedida = produtoModel.UnidadeMedida!,
        CodigoBarras = produtoModel.CodigoBarras!,
        EstoqueAlvo = produtoModel.EstoqueAlvo,
        Estoque = produtoModel.Estoque,
        IsAtivo = produtoModel.IsAtivo
      };

      await _produtoRepository.CreateAsync(produto);

      return Result.Ok(new ProdutoResponseModel(produto.Id));
    }

    /// <summary>
    /// Alteração de produto
    /// </summary>
    // PUT api/catalogo/{id}    
    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> PutAsync([FromRoute] string id, [FromBody] ProdutoModel produtoModel)
    {
      var isExist = await _produtoRepository.ExisteProdutoPorNome(produtoModel.Nome!, id);

      if (isExist)
        return Result.Fail<ProdutoResponseModel>("Produto já existente com o mesmo nome.");

      var produto = new Produto
      {
        Id = id,
        Nome = produtoModel.Nome!,
        Descricao = produtoModel.Descricao!,
        Preco = produtoModel.Preco!,
        UnidadeMedida = produtoModel.UnidadeMedida!,
        CodigoBarras = produtoModel.CodigoBarras!,
        EstoqueAlvo = produtoModel.EstoqueAlvo,
        Estoque = produtoModel.Estoque,
        IsAtivo = produtoModel.IsAtivo
      };

      await _produtoRepository.UpdateAsync(produto);

      return Result.Ok();
    }
  }
}