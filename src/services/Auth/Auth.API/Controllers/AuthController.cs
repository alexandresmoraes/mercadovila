using Auth.API.Models;
using Common.WebAPI.Auth;
using Common.WebAPI.Data;
using Common.WebAPI.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace Auth.API.Controllers
{
  /// <summary>
  /// Autenticação do usuário, dados do user logado, refresh token.
  /// </summary>
  [Route("api/auth")]
  [ApiController]
  public class AuthController : ControllerBase
  {
    private readonly IAuthService<IdentityUser> _authService;
    private readonly IJwtService _jwtService;
    private readonly SignInManager<IdentityUser> _signInManager;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<AuthController> _logger;
    private readonly UserManager<IdentityUser> _userManager;

    public AuthController(
      IAuthService<IdentityUser> authService,
      IJwtService jwtService,
      SignInManager<IdentityUser> signInManager,
      IUnitOfWork unitOfWork,
      ILogger<AuthController> logger,
      UserManager<IdentityUser> userManager)
    {
      _authService = authService ?? throw new ArgumentNullException(nameof(authService));
      _jwtService = jwtService ?? throw new ArgumentNullException(nameof(jwtService));
      _signInManager = signInManager ?? throw new ArgumentNullException(nameof(signInManager));
      _unitOfWork = unitOfWork ?? throw new ArgumentNullException(nameof(unitOfWork));
      _logger = logger ?? throw new ArgumentNullException(nameof(logger));
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
    }

    /// <summary>
    /// Endpoint para verificar dados do usuário autenticado
    /// </summary>
    // GET api/auth/me
    [HttpGet("me")]
    [ProducesResponseType(typeof(AccountModel), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<Result<AccountModel>> GetAsync()
    {
      var user = await _userManager.FindByIdAsync(_authService.GetUserId());

      return Result.Ok(new AccountModel
      {
        Id = user.Id,
        Email = user.Email,
        Username = user.UserName,
        Telefone = user.PhoneNumber,
        Roles = await _userManager.GetRolesAsync(user),
      });
    }

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
      _logger.LogInformation($"Login started {login}.");

      var user = await _authService.GetUserByUsernameOrEmail(login.UsernameOrEmail!);

      if (user is null)
      {
        _logger.LogWarning($"Login failed {login.UsernameOrEmail}.");
        return Result.Fail<AccessTokenDto>("Usuário ou senha não confere.");
      }

      var resultSign = await _signInManager.CheckPasswordSignInAsync(user!, login.Password, true);

      await _unitOfWork.CommitAsync(cancellationToken);

      if (resultSign.Succeeded)
      {
        _logger.LogInformation($"Login succeeded {login.UsernameOrEmail}.");
        return Result.Ok(await _jwtService.GenerateToken(user!.UserName));
      }
      else if (resultSign.IsLockedOut)
      {
        _logger.LogWarning($"Login failed {login.UsernameOrEmail}.");
        return Result.Fail<AccessTokenDto>("Usuário bloqueado.");
      }

      _logger.LogWarning($"Login failed {login.UsernameOrEmail}.");
      return Result.Fail<AccessTokenDto>($"Usuário ou senha não confere, restam {await _authService.GetFailedAccessAttempts(user)} tentativas.");
    }

    /// <summary>
    /// Gerar novo token validando refresh token
    /// </summary>
    // POST api/account/refresh-token
    [AllowAnonymous]
    [HttpPost("refresh-token")]
    [ProducesResponseType(typeof(AccessTokenDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Result), StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<Result<AccessTokenDto>>> RefreshTokenAsync([FromBody] RefreshTokenModel refreshToken)
    {
      var (tokenIsValid, username) = await _jwtService.ValidateRefreshToken(refreshToken.RefreshToken);

      if (tokenIsValid)
      {
        _logger.LogInformation($"RefreskToken generate.");
        return Result.Ok(await _jwtService.GenerateToken(username));
      }

      _logger.LogWarning($"RefreskToken invalid.");
      return Result.Fail<AccessTokenDto>("Refresh token inválido.");
    }
  }
}