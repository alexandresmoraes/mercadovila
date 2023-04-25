using Auth.API.Models;
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

    public AccountController(UserManager<IdentityUser> userManager)
    {
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
    }

    /// <summary>
    /// Criação de novos usuários
    /// </summary>
    // POST api/account
    [AllowAnonymous]
    [HttpPost]
    [ProducesResponseType(typeof(AccessTokenDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result<AccessTokenDto>> Post([FromBody] NovoUsuario novoUsuario, CancellationToken cancellationToken = default)
    {
      if (!ModelState.IsValid)
      {
        return Result.Fail<AccessTokenDto>(
          ModelState.Values
          .SelectMany(e => e.Errors)
          .Select(e => new ErrorResult(e.ErrorMessage)).ToArray());
      }

      var user = new IdentityUser
      {
        UserName = novoUsuario.Username,
        Email = novoUsuario.Email,
        EmailConfirmed = true
      };

      var result = await _userManager.CreateAsync(user, novoUsuario.Password);

      if (result.Succeeded)
      {
        return Result.Ok(new AccessTokenDto(
          accessToken: "",
          expiresIn: 1,
          tokenType: "",
          refreshToken: ""
        ));
      }

      return Result.Fail<AccessTokenDto>(
        result.Errors.Select(e => new ErrorResult(e.Description)).ToArray());
    }
  }
}