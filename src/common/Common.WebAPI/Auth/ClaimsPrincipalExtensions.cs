using System.Security.Claims;

namespace Common.WebAPI.Auth
{
  public static class ClaimsPrincipalExtensions
  {
    public static string? GetUserId(this ClaimsPrincipal principal)
    {
      if (principal is null)
      {
        throw new ArgumentException(nameof(principal));
      }

      var claim = principal.FindFirst(ClaimTypes.NameIdentifier);
      return claim?.Value;
    }

    public static string? GetUserEmail(this ClaimsPrincipal principal)
    {
      if (principal is null)
      {
        throw new ArgumentException(nameof(principal));
      }

      var claim = principal.FindFirst(ClaimTypes.Email);
      return claim?.Value;
    }

    public static string? GetUserName(this ClaimsPrincipal principal)
    {
      if (principal is null)
      {
        throw new ArgumentException(nameof(principal));
      }

      var claim = principal.FindFirst(ClaimTypes.Name);
      return claim?.Value;
    }
  }
}