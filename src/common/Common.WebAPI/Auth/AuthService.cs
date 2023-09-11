using Microsoft.AspNetCore.Http;

namespace Common.WebAPI.Auth
{
  public interface IAuthService
  {
    string GetUserId();
    string GetUserEmail();
    bool IsAuthenticated();
  }

  public class AuthService : IAuthService
  {
    private readonly IHttpContextAccessor _httpContextAccessor;

    public AuthService(IHttpContextAccessor httpContextAccessor)
    {
      _httpContextAccessor = httpContextAccessor;
    }

    public string GetUserEmail() => _httpContextAccessor.HttpContext?.User.GetUserEmail() ?? "";

    public string GetUserId() => _httpContextAccessor.HttpContext?.User.GetUserId() ?? "";

    public bool IsAuthenticated() => _httpContextAccessor.HttpContext?.User.Identity?.IsAuthenticated ?? false;
  }
}
