using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Queries;
using Catalogo.API.Data.Repositories;
using Catalogo.API.Models;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Common.WebAPI.Utils;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;

namespace Catalogo.API.Controllers
{
  /// <summary>
  /// Criar e editar produtos para gerar o catalogo
  /// </summary>
  [Route("api/produtos")]
  [Authorize("Admin")]
  [ApiController]
  public class ProdutosController : ControllerBase
  {
    private readonly ProdutoRepository _produtoRepository;
    private readonly IValidateUtils _validateUtils;
    private readonly IFileUtils _fileUtils;
    private readonly IConfiguration _configuration;
    private readonly IAuthService _authService;

    public ProdutosController(
      ProdutoRepository produtoRepository,
      IValidateUtils validateUtils,
      IFileUtils fileUtils,
      IConfiguration configuration,
      IAuthService authService)
    {
      _produtoRepository = produtoRepository;
      _validateUtils = validateUtils;
      _fileUtils = fileUtils;
      _configuration = configuration;
      _authService = authService;
    }

    /// <summary>
    /// Pega informações do produto para edição
    /// </summary>
    // GET api/produtos/{id}
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
        Nome = produto!.Nome,
        Descricao = produto.Descricao,
        ImageUrl = produto.ImageUrl,
        Preco = produto.Preco,
        UnidadeMedida = produto.UnidadeMedida,
        CodigoBarras = produto.CodigoBarras,
        EstoqueAlvo = produto.EstoqueAlvo,
        IsAtivo = produto.IsAtivo
      });
    }

    /// <summary>
    /// Retorna produtos paginados
    /// </summary>
    // GET api/produtos
    [HttpGet]
    [ProducesResponseType(typeof(PagedResult<ProdutoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<ProdutoDto>>> GetProdutosAsync([FromQuery] ProdutoQuery query)
      => Result.Ok(await _produtoRepository.GetProdutosAsync(query));

    /// <summary>
    /// Retorna detalhe do produto
    /// </summary>
    // GET api/produtos/detail
    [HttpGet("detail/{id}")]
    [ProducesResponseType(typeof(ProdutoDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<ProdutoDetailDto>> GetProdutoDetailAsync([FromRoute] string id)
    {
      var userId = _authService.GetUserId();

      var produtoDetail = await _produtoRepository.GetProdutoDetailAsync(userId, id);

      if (produtoDetail is null) return Result.NotFound<ProdutoDetailDto>();

      return Result.Ok(produtoDetail);
    }

    /// <summary>
    /// Criação de novos produtos
    /// </summary>
    // POST api/produtos    
    [HttpPost]
    [ProducesResponseType(typeof(ProdutoResponseModel), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<ProdutoResponseModel>> PostAsync([FromBody] ProdutoModel produtoModel)
    {
      var isExistPorNome = await _produtoRepository.ExisteProdutoPorNome(produtoModel.Nome!, null);
      if (isExistPorNome) return Result.Fail<ProdutoResponseModel>("Produto já existente com o mesmo nome.");

      var isExistPorCodigoBarras = await _produtoRepository.ExisteProdutoPorCodigoBarras(produtoModel.CodigoBarras!, null);
      if (isExistPorCodigoBarras) return Result.Fail<ProdutoResponseModel>("Produto já existente com o mesmo código de barras.");

      var produto = new Produto
      {
        Nome = produtoModel.Nome!,
        Descricao = produtoModel.Descricao!,
        ImageUrl = produtoModel.ImageUrl!,
        Preco = produtoModel.Preco!,
        UnidadeMedida = produtoModel.UnidadeMedida!,
        CodigoBarras = produtoModel.CodigoBarras!,
        EstoqueAlvo = produtoModel.EstoqueAlvo,
        IsAtivo = produtoModel.IsAtivo
      };

      await _produtoRepository.CreateAsync(produto);

      return Result.Ok(new ProdutoResponseModel(produto.Id));
    }

    /// <summary>
    /// Alteração de produto
    /// </summary>
    // PUT api/produtos/{id}    
    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> PutAsync([FromRoute] string id, [FromBody] ProdutoModel produtoModel)
    {
      var produto = await _produtoRepository.GetAsync(id);

      if (produto is null) return Result.NotFound();

      var isExistPorNome = await _produtoRepository.ExisteProdutoPorNome(produtoModel.Nome!, id);
      if (isExistPorNome) return Result.Fail(nameof(Produto.Nome), "Produto já existente com o mesmo nome.");

      var isExistPorCodigoBarras = await _produtoRepository.ExisteProdutoPorCodigoBarras(produtoModel.CodigoBarras!, id);
      if (isExistPorCodigoBarras) return Result.Fail(nameof(Produto.CodigoBarras), "Produto já existente com o mesmo código de barras.");

      produto.Nome = produtoModel.Nome!;
      produto.Descricao = produtoModel.Descricao!;
      produto.ImageUrl = produtoModel.ImageUrl!;
      produto.Preco = produtoModel.Preco!;
      produto.UnidadeMedida = produtoModel.UnidadeMedida!;
      produto.CodigoBarras = produtoModel.CodigoBarras!;
      produto.EstoqueAlvo = produtoModel.EstoqueAlvo;
      produto.IsAtivo = produtoModel.IsAtivo;

      await _produtoRepository.UpdateAsync(produto);

      return Result.Ok();
    }

    /// <summary>
    /// Upload imagem do produto
    /// </summary>
    // POST api/produtos/image
    [HttpPost("image")]
    [ProducesResponseType(typeof(ImageUploadModel), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<ImageUploadResponseModel>> UploadImageAsync(IFormFile? file)
    {
      var imageUploadModel = new ImageUploadModel(file);

      Result<ImageUploadResponseModel>? result = null;
      var validation = _validateUtils.ValidateModel(imageUploadModel, ref result);

      if (!validation)
        return result!;

      var imagePath = _configuration["ImagesSettings:ProdutoImagePath"] ?? "wwwroot/images/produtos";
      string filename = await _fileUtils.SaveFile(file!, imagePath);

      return Result.Ok(new ImageUploadResponseModel(filename));
    }

    /// <summary>
    /// Download imagem do produto
    /// </summary>
    // GET api/produtos/image/{filename}
    [AllowAnonymous]
    [HttpGet("image/{filename}")]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DownloadImageAsync([FromRoute] string filename)
    {
      var imagePath = _configuration["ImagesSettings:ProdutoImagePath"] ?? "wwwroot/images/produtos";
      var currentDirectory = Directory.GetCurrentDirectory();
      var fullFilename = Path.Combine(currentDirectory, imagePath, filename);

      if (System.IO.File.Exists(fullFilename))
      {
        var _contentTypeProvider = new FileExtensionContentTypeProvider();

        var extensao = Path.GetExtension(filename);

        if (_contentTypeProvider.TryGetContentType(extensao, out var contentType))
        {
          Response.Headers.Add("Content-Type", contentType);

          var arquivoBytes = await System.IO.File.ReadAllBytesAsync(fullFilename);
          return File(arquivoBytes, contentType);
        }
      }

      return NotFound();
    }

    /// <summary>
    /// Retorna lista de compras, sugestões baseadas no estoque alvo
    /// </summary>
    // GET api/produtos/lista-compra
    [HttpGet("lista-compra")]
    [ProducesResponseType(typeof(PagedResult<ListaCompraDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<ListaCompraDto>>> GetListaComprasAsync([FromQuery] ListaCompraQuery query)
      => Result.Ok(await _produtoRepository.GetListaCompraAsync(query));
  }
}