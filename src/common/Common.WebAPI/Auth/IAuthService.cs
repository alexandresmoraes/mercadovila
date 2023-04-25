namespace Common.WebAPI.Auth
{
  public interface IAuthService<TIdentityUser>
  {
    Task<TIdentityUser?> GetUserByUsernameOrEmail(string usernameOrEmail);
  }
}