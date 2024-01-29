using Auth.API.Data.Dto;
using Auth.API.Data.Entities;
using Auth.API.Data.Queries;
using Auth.API.Data.Repositories;
using Auth.API.Models;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Common.WebAPI.Utils;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;

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
    private readonly IAuthService _authService;
    private readonly IConfiguration _configuration;
    private readonly IFileUtils _fileUtils;
    private readonly IValidateUtils _validateUtils;

    public AccountController(UserManager<ApplicationUser> userManager, IUserRepository userRepository, IAuthService authService, IConfiguration configuration, IFileUtils fileUtils, IValidateUtils validateUtils)
    {
      _userManager = userManager;
      _userRepository = userRepository;
      _authService = authService;
      _configuration = configuration;
      _fileUtils = fileUtils;
      _validateUtils = validateUtils;
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
        return Result.Fail<NewAccountResponseModel>(nameof(ApplicationUser.UserName), "Usuário já existente.");

      user = await _userManager.FindByEmailAsync(newAccountModel.Email);

      if (user is not null)
        return Result.Fail<NewAccountResponseModel>(nameof(ApplicationUser.Email), "Email já existente.");

      user = new ApplicationUser
      {
        Nome = newAccountModel.Nome!,
        UserName = newAccountModel.Username,
        Email = newAccountModel.Email,
        PhoneNumber = newAccountModel.Telefone,
        IsAtivo = newAccountModel.IsAtivo,
        FotoUrl = newAccountModel.FotoUrl,
        EmailConfirmed = true,
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
      user.FotoUrl = updateAccountModel.FotoUrl;

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
    // POST api/account/photo/{userId}
    [HttpPost("photo/{userId}")]
    [ProducesResponseType(typeof(PhotoUploadResponseModel), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PhotoUploadResponseModel>> UploadImageAsync([FromRoute] string userId, IFormFile? file)
    {
      if (!_authService.GetUserId().Equals(userId) && !User.IsInRole("admin"))
        return Result.Forbidden<PhotoUploadResponseModel>();

      var photoUploadModel = new PhotoUploadModel(file);

      Result<PhotoUploadResponseModel>? result = null;
      var validation = _validateUtils.ValidateModel(photoUploadModel, ref result);

      if (!validation)
        return result!;

      var user = await _userManager.FindByIdAsync(userId);

      if (user is null)
        return Result.NotFound<PhotoUploadResponseModel>();

      string filename = await SaveFile(file!);

      return Result.Ok(new PhotoUploadResponseModel(filename));
    }

    /// <summary>
    /// Download foto do usuário
    /// </summary>
    // GET api/account/photo/{filename}
    [AllowAnonymous]
    [HttpGet("photo/{filename}")]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DownloadImageAsync([FromRoute] string filename)
    {
      var userImagePath = _configuration["ImagesSettings:UserImagePath"] ?? "wwwroot/images/users";
      var currentDirectory = Directory.GetCurrentDirectory();
      var fullFilename = Path.Combine(currentDirectory, userImagePath, filename);

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

    private async Task<string> SaveFile(IFormFile file)
    {
      var userImagePath = _configuration["ImagesSettings:UserImagePath"] ?? "wwwroot/images/users";

      return await _fileUtils.SaveFile(file, userImagePath);
    }
  }
}