using Catalogo.API.Data.Repositories;
using Common.WebAPI.Auth;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.MongoDb;
using Common.WebAPI.Results;
using Common.WebAPI.Utils;
using Common.WebAPI.WebApi;
using Microsoft.AspNetCore.Mvc;

namespace Catalogo.API.Config
{
  public static class ApiConfig
  {
    public static IServiceCollection AddApiConfiguration(this IServiceCollection services, IConfiguration configuration)
    {
      var authSettings = configuration.GetSection(nameof(AuthSettings));
      services.Configure<AuthSettings>(authSettings);
      services.AddResultFilter();
      services.AddDefaultHealthCheck().AddMongoHealthCheck(configuration);
      services.AddDefaultHealthCheckUI();
      services.AddControllers().AddJsonOptions(options =>
      {
        options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
      });
      services.AddEndpointsApiExplorer();
      services.UseMongoDb(configuration);
      services.AddOpenApi();

      services.AddSingleton<ProdutoRepository>();
      services.AddSingleton<CarrinhoItemRepository>();
      services.AddSingleton<FavoritoItemRepository>();
      services.AddSingleton<NotificacoesRepository>();

      services.Configure<ApiBehaviorOptions>(options =>
      {
        options.SuppressMapClientErrors = true;
        options.SuppressModelStateInvalidFilter = true;
      });
      services.AddUtils();

      services.AddMvc(opt =>
      {
#if DEBUG
        opt.Filters.Add<DelayDebugAttribute>();
#endif
      });

      return services;
    }

    public static IApplicationBuilder UseApiConfiguration(this WebApplication app)
    {
      app.MapHealthChecks();

      if (app.Environment.IsDevelopment())
      {
        app.UseOpenApi();
        app.MapHealthChecksUI();
      }

      app.UseMiddleware<ErrorHandlerMiddleware>();
      app.UseRouting();
      app.UseAuthentication();
      app.UseAuthorization();
      app.MapControllers();

      return app;
    }
  }
}
