using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;

namespace Common.WebAPI.Auth
{
  public static class AuthExtensions
  {
    public static IServiceCollection AddAuthServices<TIdentityUser, TKey>(this IServiceCollection services)
      where TIdentityUser : IdentityUser<TKey>
      where TKey : IEquatable<TKey>
    {
      services.AddScoped<IJwtService, JwtService<TIdentityUser, TKey>>();
      services.AddScoped<IAuthUserService<TIdentityUser>, AuthUserService<TIdentityUser, TKey>>();

      return services;
    }

    public static IServiceCollection AddAuthServices(this IServiceCollection services)
    {
      services.AddHttpContextAccessor();
      services.AddScoped<IAuthService, AuthService>();

      return services;
    }
  }
}