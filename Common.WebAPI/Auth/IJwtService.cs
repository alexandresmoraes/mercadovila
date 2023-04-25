namespace Common.WebAPI.Auth
{
  public interface IJwtService
  {
    Task<string> BuildToken(string username);
    Task<string> BuildRefreshToken(string username);
    Task<bool> ValidateRefreshToken(string refreshToken);
  }
}
