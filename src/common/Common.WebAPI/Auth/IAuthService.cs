namespace Common.WebAPI.Auth
{
  public interface IAuthService<TIdentityUser>
  {
    Task<TIdentityUser?> GetUserByUsernameOrEmail(string usernameOrEmail);
    string GetUserId();
    string GetUserEmail();
    bool IsAuthenticated();
    Task<int> GetFailedAccessAttempts(TIdentityUser user);
  }
}