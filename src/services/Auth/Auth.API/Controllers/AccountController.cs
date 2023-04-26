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
    private readonly IJwtService _jwtService;

    public AccountController(UserManager<IdentityUser> userManager, IJwtService jwtService)
    {
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
      _jwtService = jwtService ?? throw new ArgumentNullException(nameof(jwtService));
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
      var user = new IdentityUser
      {
        UserName = novoUsuario.Username,
        Email = novoUsuario.Email,
        EmailConfirmed = true
      };

      var result = await _userManager.CreateAsync(user, novoUsuario.Password);

      if (result.Succeeded)
      {
        return Result.Ok(await _jwtService.GenerateToken(user.UserName!));
      }

      return Result.Fail<AccessTokenDto>(
        result.Errors.Select(e => new ErrorResult(e.Description)).ToArray());
    }
  }
}