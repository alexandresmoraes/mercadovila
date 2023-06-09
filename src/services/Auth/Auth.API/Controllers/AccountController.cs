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
using System.ComponentModel.DataAnnotations;

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
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
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
    [ProducesResponseType(typeof(PagedResult<UserDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result<PagedResult<UserDto>>> GetUsersAsync([FromQuery] UserQuery query)
      => Result.Ok(await _userRepository.GetUsersPagination(query));

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
      var user = new ApplicationUser
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
    // [Authorize("Admin")]
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
    // PUT api/account/{id}/photo
    [Authorize("MeOrAdmin")]
    [HttpPost("{id}/photo")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<Result> UploadImageAsync([FromRoute] string id, IFormFile photo)
    {
      if (!_authService.GetUserId().Equals(id) && !User.IsInRole("admin"))
        return Result.Forbidden();

      var photoUploadModel = new PhotoUploadModel(photo);

      var context = new ValidationContext(photoUploadModel);
      var validationResults = new List<ValidationResult>();
      var isValid = Validator.TryValidateObject(photoUploadModel, context, validationResults, true);
      if (!isValid)
      {
        return Result.Fail(validationResults.Select(e => new ErrorResult(e.ErrorMessage!)).ToArray());
      }

      var user = await _userManager.FindByIdAsync(id);

      if (user is null)
        return Result.NotFound();

      return Result.Ok();
    }
  }
}