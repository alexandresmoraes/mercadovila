using Auth.API.Data.Dto;
using Auth.API.Data.Entities;
using Auth.API.Data.Queries;
using Auth.API.Data.Repositories;
using Auth.API.Models;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using System.ComponentModel.DataAnnotations;
using System.Net.Http.Headers;

namespace Auth.API.Controllers
{
  /// <summary>
  /// Criar novas contas de usuário, alterar e adicionar roles
  /// </summary>
  [Route("api/account")]
  [ApiController]
  public class AccountController : ControllerBase
  {
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IUserRepository _userRepository;
    private readonly IAuthService<ApplicationUser> _authService;

    public AccountController(UserManager<ApplicationUser> userManager, IUserRepository userRepository, IAuthService<ApplicationUser> authService)
    {
      _userManager = userManager;
      _userRepository = userRepository;
      _authService = authService;
    }

    /// <summary>
    /// Pega informações da conta
    /// </summary>
    // GET api/account/{id}
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(AccountModel), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<AccountModel>> GetAsync([FromRoute] string id)
    {
      if (!_authService.GetUserId().Equals(id) && !User.IsInRole("admin"))
        return Result.Forbidden<AccountModel>();

      var user = await _userManager.FindByIdAsync(id);

      if (user is not null)
      {
        return Result.Ok(new AccountModel(
          id: user.Id,
          nome: user.Nome,
          email: user.Email,
          username: user.UserName,
          telefone: user.PhoneNumber,
          fotoUrl: user.FotoUrl,
          isAtivo: user.IsAtivo,
          roles: await _userManager.GetRolesAsync(user)
        ));
      }

      return Result.NotFound<AccountModel>();
    }

    /// <summary>
    /// Retorna usuários paginados
    /// </summary>
    // GET api/account    
    [Authorize("Admin")]
    [HttpGet]
    [ProducesResponseType(typeof(PagedResult<AccountDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<AccountDto>>> GetUsersAsync([FromQuery] UserQuery query)
      => Result.Ok(await _userRepository.GetUsersPaginationAsync(query));

    /// <summary>
    /// Criação de novos usuários
    /// </summary>
    // POST api/account
    [Authorize("Admin")]
    [HttpPost]
    [ProducesResponseType(typeof(NewAccountResponseModel), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<NewAccountResponseModel>> PostAsync([FromBody] NewAndUpdateAccountModel newAccountModel)
    {
      var user = await _userManager.FindByNameAsync(newAccountModel.Username);

      if (user is not null)
        return Result.Fail<NewAccountResponseModel>("Usuário já existente.");

      user = await _userManager.FindByEmailAsync(newAccountModel.Email);

      if (user is not null)
        return Result.Fail<NewAccountResponseModel>("Email já existente.");

      user = new ApplicationUser
      {
        Nome = newAccountModel.Nome!,
        UserName = newAccountModel.Username,
        Email = newAccountModel.Email,
        PhoneNumber = newAccountModel.Telefone,
        EmailConfirmed = true,
        IsAtivo = newAccountModel.IsAtivo
      };

      var result = await _userManager.CreateAsync(user, newAccountModel.Password);

      if (result.Succeeded)
      {
        if (newAccountModel.IsAdmin)
        {
          await _userManager.AddToRoleAsync(user, "admin");
        }

        return Result.Created(new NewAccountResponseModel(user.Id));
      }

      return Result.Fail<NewAccountResponseModel>(result.Errors.Select(e => new ErrorResult(e.Description)).ToArray());
    }

    /// <summary>
    /// Alteração de conta de usuário
    /// </summary>
    // PUT api/account/{id}    
    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> PutAsync([FromRoute] string id, [FromBody] NewAndUpdateAccountModel updateAccountModel)
    {
      if (!_authService.GetUserId().Equals(id) && !User.IsInRole("admin"))
        return Result.Forbidden();

      var user = await _userManager.FindByIdAsync(id);

      if (user is null)
        return Result.NotFound();

      user.Nome = updateAccountModel.Nome!;
      user.Email = updateAccountModel.Email;
      user.PhoneNumber = updateAccountModel.Telefone;
      user.UserName = updateAccountModel.Username;
      user.IsAtivo = updateAccountModel.IsAtivo;

      var result = await _userManager.UpdateAsync(user);

      if (result.Succeeded)
      {
        result = await _userManager.RemovePasswordAsync(user);

        if (result.Succeeded)
        {
          result = await _userManager.AddPasswordAsync(user, updateAccountModel.Password);

          if (updateAccountModel.IsAdmin && !await _userManager.IsInRoleAsync(user, "admin"))
          {
            await _userManager.AddToRoleAsync(user, "admin");
          }
          else if (!updateAccountModel.IsAdmin && await _userManager.IsInRoleAsync(user, "admin"))
          {
            await _userManager.RemoveFromRoleAsync(user, "admin");
          }

          return Result.Ok();
        }
      }

      return Result.Fail(result.Errors.Select(e => new ErrorResult(e.Code, null, e.Description)).ToArray());
    }

    /// <summary>
    /// Upload foto do usuário
    /// </summary>
    // POST api/account/{userId}
    [HttpPost("photo/{userId}")]
    [ProducesResponseType(typeof(PhotoUploadResponseModel), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PhotoUploadResponseModel>> UploadImageAsync([FromRoute] string userId, IFormFile foto)
    {
      if (!_authService.GetUserId().Equals(userId) && !User.IsInRole("admin"))
        return Result.Forbidden<PhotoUploadResponseModel>();

      var photoUploadModel = new PhotoUploadModel(foto);

      Result<PhotoUploadResponseModel>? result = null;
      var validation = ValidatePhotoUploadModel(photoUploadModel, ref result);

      if (!validation)
        return result!;

      var user = await _userManager.FindByIdAsync(userId);

      if (user is null)
        return Result.NotFound<PhotoUploadResponseModel>();

      var currentDirectory = Directory.GetCurrentDirectory();
      var filename = Guid.NewGuid().ToString() + Path.GetExtension(foto.FileName);
      var caminhoCompleto = Path.Combine(currentDirectory, "app", "uploads", filename);

      string diretorio = Path.GetDirectoryName(caminhoCompleto)!;
      if (!Directory.Exists(diretorio))
      {
        Directory.CreateDirectory(diretorio);
      }

      using (var stream = new FileStream(caminhoCompleto, FileMode.Create))
      {
        await foto.CopyToAsync(stream);
      }

      return Result.Ok(new PhotoUploadResponseModel(filename));
    }

    /// <summary>
    /// Download foto do usuário
    /// </summary>
    // GET api/account/photo/{filename}
    [AllowAnonymous]
    [HttpGet("photo/{filename}")]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> DownloadImageAsync([FromRoute] string filename)
    {
      var currentDirectory = Directory.GetCurrentDirectory();
      var fullFilename = Path.Combine(currentDirectory, "app", "uploads", filename);

      if (System.IO.File.Exists(fullFilename))
      {
        var _contentTypeProvider = new FileExtensionContentTypeProvider();

        var extensao = Path.GetExtension(filename);

        if (_contentTypeProvider.TryGetContentType(extensao, out var contentType))
        {
          var contentDisposition = new ContentDispositionHeaderValue("inline")
          {
            FileName = filename
          };

          Response.Headers.Add("Content-Disposition", contentDisposition.ToString());
          Response.Headers.Add("Content-Type", contentType);

          var arquivoBytes = await System.IO.File.ReadAllBytesAsync(fullFilename);
          return File(arquivoBytes, contentType);
        }
      }

      return NotFound();
    }

    private bool ValidatePhotoUploadModel(PhotoUploadModel photoUploadModel, ref Result<PhotoUploadResponseModel>? result)
    {
      var context = new ValidationContext(photoUploadModel);
      var validationResults = new List<ValidationResult>();
      var isValid = Validator.TryValidateObject(photoUploadModel, context, validationResults, true);

      if (!isValid)
      {
        result = Result.Fail<PhotoUploadResponseModel>(validationResults.Select(e => new ErrorResult(e.ErrorMessage!)).ToArray());
      }

      return isValid;
    }
  }
}