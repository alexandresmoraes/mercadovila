namespace Common.WebAPI.Auth
{
  public interface IJwtService
  {
    Task<string> GenerateToken(string username);
    Task<string> GenerateRefreshToken(string username);
    Task<bool> ValidateRefreshToken(string refreshToken);
  }
}
