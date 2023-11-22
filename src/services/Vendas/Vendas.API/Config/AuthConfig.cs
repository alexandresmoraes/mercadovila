using Common.WebAPI.Auth;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Text;

namespace Vendas.API.Config
{
  public static class AuthConfig
  {
    public static IServiceCollection AddAuthConfig(this IServiceCollection services, IConfiguration configuration)
    {
      var authSettings = configuration.GetSection(nameof(AuthSettings));

      var signingKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(authSettings[nameof(AuthSettings.SecretKey)]));

      services
        .AddAuthentication(opt =>
        {
          opt.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
          opt.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
        })
        .AddJwtBearer(opt =>
        {
          opt.RequireHttpsMetadata = true;
          opt.ClaimsIssuer = authSettings[nameof(AuthSettings.Issuer)];
          opt.TokenValidationParameters = new TokenValidationParameters
          {
            ValidateIssuer = true,
            ValidIssuer = authSettings[nameof(AuthSettings.Issuer)],
            ValidateAudience = true,
            ValidAudience = authSettings[nameof(AuthSettings.Audience)],
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = signingKey,
            RequireExpirationTime = false,
            ValidateLifetime = true,
            ClockSkew = TimeSpan.Zero
          };

          opt.Events = new JwtBearerEvents
          {
            OnAuthenticationFailed = context =>
            {
              if (context.Exception is SecurityTokenExpiredException)
              {
                context.Response.Headers.Add("token-expired", "true");
              }
              return Task.CompletedTask;
            }
          };
        });

      services.AddAuthorization((opt) =>
      {
        opt.AddPolicy("Admin", policy => policy.RequireClaim(ClaimTypes.Role, "admin"));
      });

      services.AddMvc(opt =>
      {
        opt.Filters.Add(new AuthorizeFilter());
      });

      return services;
    }
  }
}
