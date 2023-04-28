using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;

namespace Common.WebAPI.Auth
{
  public class AuthService<TIdentityUser, TKey> : IAuthService<TIdentityUser>
    where TIdentityUser : IdentityUser<TKey>
    where TKey : IEquatable<TKey>
  {
    private readonly UserManager<TIdentityUser> _userManager;
    private readonly IHttpContextAccessor _accessor;
    private readonly IOptions<AuthSettings> _settings;

    public AuthService(UserManager<TIdentityUser> userManager, IHttpContextAccessor accessor, IOptions<AuthSettings> settings)
    {
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
      _accessor = accessor ?? throw new ArgumentNullException(nameof(accessor));
      _settings = settings ?? throw new ArgumentNullException(nameof(settings));
    }

    public async Task<int> GetFailedAccessAttempts(TIdentityUser user)
      => _settings.Value.MaxFailedAccessAttempts - await _userManager.GetAccessFailedCountAsync(user);

    public async Task<TIdentityUser?> GetUserByUsernameOrEmail(string usernameOrEmail)
      => (await _userManager.FindByEmailAsync(usernameOrEmail)
        ?? await _userManager.FindByNameAsync(usernameOrEmail))!;

    public string GetUserEmail() => _accessor.HttpContext?.User.GetUserEmail() ?? "";

    public string GetUserId() => _accessor.HttpContext?.User.GetUserId() ?? "";

    public bool IsAuthenticated() => _accessor.HttpContext?.User.Identity?.IsAuthenticated ?? false;
  }
}
