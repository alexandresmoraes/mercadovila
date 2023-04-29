﻿using Auth.API.Models;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace Auth.API.Controllers
{
  [Route("api/account")]
  [ApiController]
  public class AccountController : ControllerBase
  {
    private readonly UserManager<IdentityUser> _userManager;
    private readonly RoleManager<IdentityRole> _roleManager;
    private readonly IAuthService<IdentityUser> _authService;
    private readonly IJwtService _jwtService;

    public AccountController(UserManager<IdentityUser> userManager, RoleManager<IdentityRole> roleManager, IAuthService<IdentityUser> authService, IJwtService jwtService)
    {
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
      _roleManager = roleManager ?? throw new ArgumentNullException(nameof(roleManager));
      _authService = authService ?? throw new ArgumentNullException(nameof(authService));
      _jwtService = jwtService ?? throw new ArgumentNullException(nameof(jwtService));
    }

    /// <summary>
    /// Pega informações da conta
    /// </summary>
    // GET api/account/{id}
#if DEBUG
    [AllowAnonymous]
#else
    [Authorize(Roles = "admin")]
#endif
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(AccountModel), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result<AccountModel>> Post([FromRoute] string id)
    {
      var user = await _userManager.FindByIdAsync(id);

      if (user is not null)
      {
#if DEBUG
        await _userManager.AddToRoleAsync(user, "admin");
#endif

        return Result.Ok(new AccountModel
        {
          Id = user.Id,
          Email = user.Email,
          Username = user.UserName,
          PhoneNumber = user.PhoneNumber
        });
      }

      return Result.NotFound<AccountModel>("Usuário não encontrado.");
    }

    /// <summary>
    /// Criação de novos usuários
    /// </summary>
    // POST api/account
#if DEBUG
    [AllowAnonymous]
#else
    [Authorize(Roles = "admin")]
#endif
    [HttpPost]
    [ProducesResponseType(typeof(AccessTokenDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result<AccessTokenDto>> Post([FromBody] NewAccountModel newAccountModel)
    {
      var user = new IdentityUser
      {
        UserName = newAccountModel.Username,
        Email = newAccountModel.Email,
        PhoneNumber = newAccountModel.PhoneNumber,
        EmailConfirmed = true
      };

      var result = await _userManager.CreateAsync(user, newAccountModel.Password);

      if (result.Succeeded)
      {
#if DEBUG
        await _userManager.AddToRoleAsync(user, "admin");
#endif

        return Result.Ok(await _jwtService.GenerateToken(user.UserName!));
      }

      return Result.Fail<AccessTokenDto>(
        result.Errors.Select(e => new ErrorResult(e.Description)).ToArray());
    }

    /// <summary>
    /// Criação de novos usuários
    /// </summary>
    // PUT api/account/{id}
#if DEBUG
    [AllowAnonymous]
#else
    [Authorize(Roles = "admin")]
#endif
    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result> Put([FromRoute] string id, [FromBody] UpdateAccountModel updateAccountModel)
    {
      var user = await _userManager.FindByIdAsync(id);

      if (user is null)
        return Result.NotFound("Usuário não econtrado.");

      user.Email = updateAccountModel.Email;
      user.PhoneNumber = updateAccountModel.PhoneNumber;
      user.UserName = updateAccountModel.Username;

      var result = await _userManager.UpdateAsync(user);

      if (result.Succeeded)
      {
        result = await _userManager.RemovePasswordAsync(user);

        if (result.Succeeded)
        {
          result = await _userManager.AddPasswordAsync(user, updateAccountModel.Password);

          return Result.Ok();
        }
      }

      return Result.Fail(result.Errors.Select(e => new ErrorResult(e.Code, null, e.Description)).ToArray());
    }

    /// <summary>
    /// Adicionar role para o usuário
    /// </summary>
    // POST api/account/role/{userId}/{roleName}
#if DEBUG
    [AllowAnonymous]
#else
    [Authorize(Roles = "admin")]
#endif
    [Route("role/{userId}/{roleName}")]
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result> PostRole([FromRoute] string userId, [FromRoute] string roleName)
    {
      if (!await _roleManager.RoleExistsAsync(roleName))
      {
        return Result.NotFound("Role não encontrada.");
      }

      var authUser = await _authService.GetUserByUsernameOrEmail(userId)
        ?? await _userManager.FindByIdAsync(userId);

      if (authUser is null)
      {
        return Result.NotFound("Usuário não encontrado.");
      }

      await _userManager.AddToRoleAsync(authUser, roleName);

      return Result.Ok();
    }
  }
}