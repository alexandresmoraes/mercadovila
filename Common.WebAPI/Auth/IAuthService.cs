namespace Common.WebAPI.Auth
{
  public interface IAuthService<TIdentityUser, TKey>
  {
    Task<TIdentityUser?> GetUserByUsernameOrEmail(string usernameOrEmail);
  }
}