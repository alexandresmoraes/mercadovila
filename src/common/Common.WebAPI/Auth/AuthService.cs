using Microsoft.AspNetCore.Identity;

namespace Common.WebAPI.Auth
{
  public class AuthService<TIdentityUser, TKey> : IAuthService<TIdentityUser>
    where TIdentityUser : IdentityUser<TKey>
    where TKey : IEquatable<TKey>
  {
    private readonly UserManager<TIdentityUser> _userManager;

    public AuthService(UserManager<TIdentityUser> userManager)
    {
      _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
    }

    public async Task<TIdentityUser?> GetUserByUsernameOrEmail(string usernameOrEmail)
      => (await _userManager.FindByEmailAsync(usernameOrEmail)
        ?? await _userManager.FindByNameAsync(usernameOrEmail))!;
  }
}
