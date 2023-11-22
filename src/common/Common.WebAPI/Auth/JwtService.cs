using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using JwtRegisteredClaimNames = Microsoft.IdentityModel.JsonWebTokens.JwtRegisteredClaimNames;

namespace Common.WebAPI.Auth
{
  public class JwtService<TIdentityUser, TKey> : IJwtService
    where TIdentityUser : IdentityUser<TKey>
    where TKey : IEquatable<TKey>
  {
    private const string LAST_REFRESH_TOKEN = "__LastRefreshToken";

    private readonly UserManager<TIdentityUser> _userManager;
    private readonly IOptions<AuthSettings> _settings;
    private readonly IAuthUserService<TIdentityUser> _authService;

    public JwtService(UserManager<TIdentityUser> userManager, IOptions<AuthSettings> settings, IAuthUserService<TIdentityUser> authService)
    {
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
      _settings = settings ?? throw new ArgumentNullException(nameof(settings));
      _authService = authService ?? throw new ArgumentNullException(nameof(authService));
    }

    public async Task<AccessTokenDto> GenerateToken(string username)
    {
      var tokenHandler = new JwtSecurityTokenHandler();
      var key = GetCurrentKey();
      var user = await _authService.GetUserByUsernameOrEmail(username);

      var identityClaims = new ClaimsIdentity();

      identityClaims.AddClaim(new Claim(JwtRegisteredClaimNames.Sub, user!.Id.ToString()!));
      identityClaims.AddClaim(new Claim(JwtRegisteredClaimNames.Email, user.Email!));
      identityClaims.AddClaim(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
      identityClaims.AddClaim(new Claim(JwtRegisteredClaimNames.Iat, ToUnixEpochDate(DateTime.UtcNow).ToString(), ClaimValueTypes.Integer64));

      var userRoles = await _userManager.GetRolesAsync(user);
      userRoles.ToList().ForEach(r => identityClaims.AddClaim(new Claim(ClaimTypes.Role, r)));

      var userClaims = await _userManager.GetClaimsAsync(user);
      RemoveRefreshToken(userClaims);
      identityClaims.AddClaims(userClaims);

      var token = tokenHandler.CreateToken(new SecurityTokenDescriptor
      {
        Issuer = _settings.Value.Issuer,
        Audience = _settings.Value.Audience,
        Subject = identityClaims,
        Expires = DateTime.UtcNow.AddMinutes(_settings.Value.ExpiresIn),
        NotBefore = DateTime.UtcNow,
        SigningCredentials = key,
        TokenType = "jwt"
      });

      return new AccessTokenDto(
        accessToken: tokenHandler.WriteToken(token),
        expiresIn: _settings.Value.ExpiresIn,
        tokenType: JwtBearerDefaults.AuthenticationScheme,
        refreshToken: await GenerateRefreshToken(username)
      );
    }

    public async Task<string> GenerateRefreshToken(string username)
    {
      var jti = Guid.NewGuid().ToString();
      var key = GetCurrentKey();
      var user = await _authService.GetUserByUsernameOrEmail(username);
      var claims = new List<Claim>
      {
        new(JwtRegisteredClaimNames.Sub, user!.Id.ToString()!),
        new(JwtRegisteredClaimNames.Jti, jti)
      };

      var identityClaims = new ClaimsIdentity();
      identityClaims.AddClaims(claims);

      var handler = new JwtSecurityTokenHandler();

      var securityToken = handler.CreateToken(new SecurityTokenDescriptor
      {
        Issuer = _settings.Value.Issuer,
        Audience = _settings.Value.Audience,
        SigningCredentials = key,
        Subject = identityClaims,
        NotBefore = DateTime.UtcNow,
        Expires = DateTime.UtcNow.AddDays(_settings.Value.RefreshTokenExpiration),
        TokenType = "refreshtoken"
      });
      await UpdateLastRefreshToken(jti, user);
      return handler.WriteToken(securityToken);
    }

    public async Task<(bool, string)> ValidateRefreshToken(string refreshToken)
    {
      var handler = new JsonWebTokenHandler();

      var result = handler.ValidateToken(refreshToken, new TokenValidationParameters()
      {
        RequireSignedTokens = false,
        ValidIssuer = _settings.Value.Issuer,
        ValidAudience = _settings.Value.Audience,
        IssuerSigningKey = GetCurrentKey().Key,
      });

      if (!result.IsValid)
        throw new SecurityTokenException("Refresh token inválido");

      var user = await _userManager.FindByIdAsync(GetUserId(result.ClaimsIdentity)!);

      if (user is null)
        throw new SecurityTokenException("Usuário não encontrado");

      var claims = await _userManager.GetClaimsAsync(user!);

      var jti = GetJwtId(result.ClaimsIdentity);

      if (!claims.Any(c => c.Type == LAST_REFRESH_TOKEN && c.Value == jti))
        throw new SecurityTokenException("Refresh token usado");

      if (user!.LockoutEnabled)
        if (user.LockoutEnd < DateTime.Now)
          throw new SecurityTokenException("Usuário bloqueado");

      return (true, user.UserName);
    }

    private async Task UpdateLastRefreshToken(string jti, TIdentityUser user)
    {

      var claims = await _userManager.GetClaimsAsync(user);
      var newLastRtClaim = new Claim(LAST_REFRESH_TOKEN, jti);

      var claimLastRt = claims.FirstOrDefault(f => f.Type == LAST_REFRESH_TOKEN);
      if (claimLastRt != null)
        await _userManager.ReplaceClaimAsync(user, claimLastRt, newLastRtClaim);
      else
        await _userManager.AddClaimAsync(user, newLastRtClaim);
    }

    private void RemoveRefreshToken(ICollection<Claim> claims)
    {
      var refreshToken = claims.FirstOrDefault(f => f.Type == LAST_REFRESH_TOKEN);
      if (refreshToken is not null)
        claims.Remove(refreshToken);
    }

    private string? GetJwtId(ClaimsIdentity principal) => principal.FindFirst(JwtRegisteredClaimNames.Jti)?.Value;

    private string? GetUserId(ClaimsIdentity principal)
    {
      if (principal is null)
      {
        throw new ArgumentException(nameof(principal));
      }

      var claim = principal.FindFirst(JwtRegisteredClaimNames.Sub);
      if (claim is null)
        claim = principal.FindFirst(ClaimTypes.NameIdentifier);

      return claim?.Value;
    }

    private long ToUnixEpochDate(DateTime date)
        => (long)Math.Round((date.ToUniversalTime() - new DateTimeOffset(1970, 1, 1, 0, 0, 0, TimeSpan.Zero))
            .TotalSeconds);
    private SigningCredentials GetCurrentKey()
      => new SigningCredentials(new SymmetricSecurityKey(Encoding.ASCII.GetBytes(_settings.Value.SecretKey)), SecurityAlgorithms.HmacSha256Signature);
  }
}