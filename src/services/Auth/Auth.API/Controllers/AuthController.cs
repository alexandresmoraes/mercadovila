using Auth.API.Models;
using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace Auth.API.Controllers
{
  [Route("api/auth")]
  [ApiController]
  public class AuthController : ControllerBase
  {
    private readonly IAuthService<IdentityUser> _authService;
    private readonly IJwtService _jwtService;
    private readonly SignInManager<IdentityUser> _signInManager;

    public AuthController(IAuthService<IdentityUser> authService, IJwtService jwtService, SignInManager<IdentityUser> signInManager)
    {
      _authService = authService ?? throw new ArgumentNullException(nameof(authService));
      _jwtService = jwtService ?? throw new ArgumentNullException(nameof(jwtService));
      _signInManager = signInManager ?? throw new ArgumentNullException(nameof(signInManager));
    }

    /// <summary>
    /// Endpoint para verificar se o usuário está autorizado
    /// </summary>
    // GET api/auth
    [HttpGet]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public Result GetAsync() => Result.Ok();

    /// <summary>
    /// Login de usuário
    /// </summary>
    // POST api/auth/login    
    [AllowAnonymous]
    [HttpPost("login")]
    [ProducesResponseType(typeof(AccessTokenDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result<AccessTokenDto>> LoginAsync([FromBody] LoginModel login, CancellationToken cancellationToken = default)
    {
      var user = await _authService.GetUserByUsernameOrEmail(login.UsernameOrEmail!);

      if (user is null)
      {
        return Result.Fail<AccessTokenDto>("Usuário ou senha não confere.");
      }

      var resultSign = await _signInManager.CheckPasswordSignInAsync(user!, login.Password, false);

      if (resultSign.Succeeded)
      {
        return Result.Ok(await _jwtService.GenerateToken(user!.UserName));
      }
      else if (resultSign.IsLockedOut)
      {
        return Result.Fail<AccessTokenDto>("Usuário bloqueado.");
      }

      return Result.Fail<AccessTokenDto>("Usuário ou senha não confere.");
    }
  }
}