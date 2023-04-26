using Auth.API.Data;
using Microsoft.AspNetCore.Identity;

namespace Auth.API.Config;

public static class IdentityConfig
{
  public static IServiceCollection AddIdentityConfiguration(this IServiceCollection services, IConfiguration configuration)
  {
    services.AddIdentity<IdentityUser, IdentityRole>(o =>
    {
      o.Password.RequireDigit = false;
      o.Password.RequireLowercase = false;
      o.Password.RequireNonAlphanumeric = false;
      o.Password.RequireUppercase = false;
      o.Password.RequiredUniqueChars = 0;
      o.Password.RequiredLength = 4;
    }).AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

    return services;
  }
}