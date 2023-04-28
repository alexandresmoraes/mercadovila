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
    public async Task<Result<AccessTokenDto>> Post([FromBody] NovoUsuarioModel novoUsuario, CancellationToken cancellationToken = default)
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
#if DEBUG
        await _userManager.AddToRoleAsync(user, "admin");
#endif

        return Result.Ok(await _jwtService.GenerateToken(user.UserName!));
      }

      return Result.Fail<AccessTokenDto>(
        result.Errors.Select(e => new ErrorResult(e.Description)).ToArray());
    }

    /// <summary>
    /// Adicionar role para o usuário
    /// </summary>
    // POST api/account/role/{user}/{role}
#if DEBUG
    [AllowAnonymous]
#else
    [Authorize(Roles = "admin")]
#endif
    [Route("role/{user}/{role}")]
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result> PostRole([FromRoute] string user, [FromRoute] string role, CancellationToken cancellationToken = default)
    {
      if (!await _roleManager.RoleExistsAsync(role))
      {
        return Result.NotFound("Role não encontrada.");
      }

      var authUser = await _authService.GetUserByUsernameOrEmail(user)
        ?? await _userManager.FindByIdAsync(user);

      if (authUser is null)
      {
        return Result.NotFound("Usuário não encontrado.");
      }

      await _userManager.AddToRoleAsync(authUser, role);

      return Result.Ok();
    }
  }
}