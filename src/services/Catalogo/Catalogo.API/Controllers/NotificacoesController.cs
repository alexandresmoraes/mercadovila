using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Queries;
using Catalogo.API.Data.Repositories;
using Catalogo.API.Models;
using Common.WebAPI.Results;
using Common.WebAPI.Utils;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;

namespace Catalogo.API.Controllers
{
  /// <summary>
  /// Criar, editar e listar notificacoes
  /// </summary>
  [Route("api/notificacoes")]  
  [ApiController]
  public class NotificacoesController : ControllerBase
  {
    private readonly NotificacoesRepository _notificacoesRepository;
    private readonly IValidateUtils _validateUtils;
    private readonly IFileUtils _fileUtils;
    private readonly IConfiguration _configuration;

    public NotificacoesController(NotificacoesRepository notificacoesRepository, IValidateUtils validateUtils, IFileUtils fileUtils, IConfiguration configuration)
    {
      _notificacoesRepository = notificacoesRepository;
      _validateUtils = validateUtils;
      _fileUtils = fileUtils;
      _configuration = configuration;
    }

    /// <summary>
    /// Pega informações da notificação para edição
    /// </summary>
    // GET api/notificacoes/{id}
    [HttpGet("{id}")]
    [Authorize("Admin")]
    [ProducesResponseType(typeof(NotificacaoModel), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<NotificacaoModel>> GetAsync([FromRoute] string id)
    {
      var notificacao = await _notificacoesRepository.GetAsync(id);

      if (notificacao is null)
        Result.NotFound();

      return Result.Ok(new NotificacaoModel
      {
        Titulo = notificacao!.Titulo,
        Mensagem = notificacao!.Mensagem,
        ImageUrl = notificacao.ImageUrl        
      });
    }

    /// <summary>
    /// Retorna notificações paginadas
    /// </summary>
    // GET api/notificacoes
    [HttpGet]
    [Authorize]
    [ProducesResponseType(typeof(PagedResult<NotificacaoDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<NotificacaoDto>>> GetNotificacoesAsync([FromQuery] NotificacaoQuery query)
      => Result.Ok(await _notificacoesRepository.GetNotificacoesAsync(query));

    /// <summary>
    /// Criação de novas notificações
    /// </summary>
    // POST api/notificacoes    
    [HttpPost]
    [Authorize("Admin")]
    [ProducesResponseType(typeof(NotificacaoResponseModel), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<NotificacaoResponseModel>> PostAsync([FromBody] NotificacaoModel notificacaoModel)
    {      
      var notificacao = new Notificacao
      {
        Titulo = notificacaoModel.Titulo,
        Mensagem = notificacaoModel.Mensagem,
        ImageUrl = notificacaoModel.ImageUrl        
      };

      await _notificacoesRepository.CreateAsync(notificacao);

      return Result.Ok(new NotificacaoResponseModel(notificacao.Id));
    }

    /// <summary>
    /// Alteração de notificação
    /// </summary>
    // PUT api/notificacoes/{id}    
    [HttpPut("{id}")]
    [Authorize("Admin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> PutAsync([FromRoute] string id, [FromBody] NotificacaoModel notificacaoModel)
    {
      var notificacao = await _notificacoesRepository.GetAsync(id);

      if (notificacao is null)
        return Result.NotFound();
      
      notificacao.Titulo = notificacaoModel.Titulo;
      notificacao.Mensagem = notificacaoModel.Mensagem;
      notificacao.ImageUrl = notificacaoModel.ImageUrl;

      await _notificacoesRepository.UpdateAsync(notificacao);

      return Result.Ok();
    }

    /// <summary>
    /// Remover notificação
    /// </summary>
    // DELETE api/notificacoes/{id}    
    [HttpDelete("{id}")]
    [Authorize("Admin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> DeleteAsync([FromRoute] string id)
    {
      var result = await _notificacoesRepository.DeleteAsync(id);

      return result ? Result.Ok() : Result.NotFound();
    }

    /// <summary>
    /// Upload imagem da notificação
    /// </summary>
    // POST api/notificacao/image
    [HttpPost("image")]
    [Authorize("Admin")]
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

      var imagePath = _configuration["ImagesSettings:NotificacoesImagePath"] ?? "wwwroot/images/notificacoes";
      string filename = await _fileUtils.SaveFile(file!, imagePath);

      return Result.Ok(new ImageUploadResponseModel(filename));
    }

    /// <summary>
    /// Download imagem da notificação
    /// </summary>
    // GET api/notificacao/image/{filename}
    [AllowAnonymous]
    [HttpGet("image/{filename}")]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DownloadImageAsync([FromRoute] string filename)
    {
      var imagePath = _configuration["ImagesSettings:NotificacoesImagePath"] ?? "wwwroot/images/notificacoes";
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
  }
}