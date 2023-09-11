using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;

namespace Common.WebAPI.Auth
{
  public interface IAuthUserService<TIdentityUser>
  {
    Task<TIdentityUser?> GetUserByUsernameOrEmail(string usernameOrEmail);
    Task<int> GetFailedAccessAttempts(TIdentityUser user);
  }

  public class AuthUserService<TIdentityUser, TKey> : IAuthUserService<TIdentityUser>
    where TIdentityUser : IdentityUser<TKey>
    where TKey : IEquatable<TKey>
  {
    private readonly UserManager<TIdentityUser> _userManager;
    private readonly IOptions<AuthSettings> _settings;

    public AuthUserService(UserManager<TIdentityUser> userManager, IOptions<AuthSettings> settings)
    {
      _userManager = userManager;
      _settings = settings;
    }

    public async Task<int> GetFailedAccessAttempts(TIdentityUser user)
      => _settings.Value.MaxFailedAccessAttempts - await _userManager.GetAccessFailedCountAsync(user);

    public async Task<TIdentityUser?> GetUserByUsernameOrEmail(string usernameOrEmail)
      => (await _userManager.FindByEmailAsync(usernameOrEmail)
        ?? await _userManager.FindByNameAsync(usernameOrEmail))!;
  }
}
