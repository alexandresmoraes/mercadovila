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
  using Result = Common.WebAPI.Results.Result;

  /// <summary>
  /// Criar novas contas de usuário, alterar e adicionar roles
  /// </summary>
  [Route("api/account")]
  [ApiController]
#if DEBUG
  [AllowAnonymous]
#else
  [Authorize(Roles = "admin")]
#endif
  public class AccountController : ControllerBase
  {
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IJwtService _jwtService;
    private readonly IUserRepository _userRepository;

    public AccountController(UserManager<ApplicationUser> userManager, IJwtService jwtService, IUserRepository userRepository)
    {
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
      _jwtService = jwtService ?? throw new ArgumentNullException(nameof(jwtService));
      _userRepository = userRepository ?? throw new ArgumentNullException(nameof(userRepository));
    }

    /// <summary>
    /// Pega informações da conta
    /// </summary>
    // GET api/account/{id}
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(AccountModel), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result<AccountModel>> GetAsync([FromRoute] string id)
    {
      var user = await _userManager.FindByIdAsync(id);

      if (user is not null)
      {
        return Result.Ok(new AccountModel
        {
          Id = user.Id,
          Email = user.Email,
          Username = user.UserName,
          PhoneNumber = user.PhoneNumber,
          Roles = await _userManager.GetRolesAsync(user),
        });
      }

      return Result.NotFound<AccountModel>("Usuário não encontrado.");
    }

    /// <summary>
    /// Retorna usuários paginados
    /// </summary>
    // GET api/account
    [HttpGet]
    [ProducesResponseType(typeof(PagedResult<UserDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result<PagedResult<UserDto>>> GetUsersAsync([FromQuery] UserQuery query)
      => Result.Ok(await _userRepository.GetUsersPagination(query));

    /// <summary>
    /// Criação de novos usuários
    /// </summary>
    // POST api/account
    [HttpPost]
    [ProducesResponseType(typeof(AccessTokenDto), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result<AccessTokenDto>> PostAsync([FromBody] NewAccountModel newAccountModel)
    {
      var user = new ApplicationUser
      {
        UserName = newAccountModel.Username,
        Email = newAccountModel.Email,
        PhoneNumber = newAccountModel.PhoneNumber,
        EmailConfirmed = true,
        IsActive = newAccountModel.IsActive
      };

      var result = await _userManager.CreateAsync(user, newAccountModel.Password);

      if (result.Succeeded && newAccountModel.IsAdmin)
      {
        await _userManager.AddToRoleAsync(user, "admin");

        return Result.Created(await _jwtService.GenerateToken(user.UserName!));
      }

      return Result.Fail<AccessTokenDto>(
        result.Errors.Select(e => new ErrorResult(e.Description)).ToArray());
    }

    /// <summary>
    /// Alteração de conta de usuário
    /// </summary>
    // PUT api/account/{id}
    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result> PutAsync([FromRoute] string id, [FromBody] UpdateAccountModel updateAccountModel)
    {
      var user = await _userManager.FindByIdAsync(id);

      if (user is null)
        return Result.NotFound("Usuário não econtrado.");

      user.Email = updateAccountModel.Email;
      user.PhoneNumber = updateAccountModel.PhoneNumber;
      user.UserName = updateAccountModel.Username;
      user.IsActive = updateAccountModel.IsActive;

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
    [HttpPost("{id}/photo")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result> UploadImageAsync([FromRoute] string id, IFormFile photo)
    {
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