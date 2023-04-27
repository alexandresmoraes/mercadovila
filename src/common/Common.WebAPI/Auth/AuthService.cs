using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;

namespace Common.WebAPI.Auth
{
  public class AuthService<TIdentityUser, TKey> : IAuthService<TIdentityUser>
    where TIdentityUser : IdentityUser<TKey>
    where TKey : IEquatable<TKey>
  {
    private readonly UserManager<TIdentityUser> _userManager;
    private readonly IHttpContextAccessor _accessor;

    public AuthService(UserManager<TIdentityUser> userManager, IHttpContextAccessor accessor)
    {
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
      _accessor = accessor ?? throw new ArgumentNullException(nameof(accessor));
    }

    public async Task<TIdentityUser?> GetUserByUsernameOrEmail(string usernameOrEmail)
      => (await _userManager.FindByEmailAsync(usernameOrEmail)
        ?? await _userManager.FindByNameAsync(usernameOrEmail))!;

    public string GetUserEmail() => _accessor.HttpContext?.User.GetUserEmail() ?? "";

    public string GetUserId() => _accessor.HttpContext?.User.GetUserId() ?? "";

    public bool IsAuthenticated() => _accessor.HttpContext?.User.Identity?.IsAuthenticated ?? false;
  }
}
