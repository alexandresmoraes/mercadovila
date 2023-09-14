using Auth.API.Data.Entities;
using Auth.API.Models;
using Common.WebAPI.Auth;
using Common.WebAPI.PostgreSql;
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
    private readonly IAuthUserService<ApplicationUser> _authService;
    private readonly IAuthService _authServiceWithoutUserType;
    private readonly IJwtService _jwtService;
    private readonly SignInManager<ApplicationUser> _signInManager;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<AuthController> _logger;
    private readonly UserManager<ApplicationUser> _userManager;

    public AuthController(IAuthUserService<ApplicationUser> authService, IAuthService authServiceWithoutUserType, IJwtService jwtService, SignInManager<ApplicationUser> signInManager, IUnitOfWork unitOfWork, ILogger<AuthController> logger, UserManager<ApplicationUser> userManager)
    {
      _authService = authService;
      _authServiceWithoutUserType = authServiceWithoutUserType;
      _jwtService = jwtService;
      _signInManager = signInManager;
      _unitOfWork = unitOfWork;
      _logger = logger;
      _userManager = userManager;
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
      var user = await _userManager.FindByIdAsync(_authServiceWithoutUserType.GetUserId());

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

      if (!user.IsAtivo)
      {
        _logger.LogWarning($"User is not active {login.UsernameOrEmail}.");
        return Result.Fail<AccessTokenDto>("Usuário inativo.");
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