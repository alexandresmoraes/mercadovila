using Catalogo.API.Data.Repositories;
using Common.EventBus;
using Common.WebAPI.Auth;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.MongoDb;
using Common.WebAPI.Results;
using Common.WebAPI.Utils;
using Common.WebAPI.WebApi;
using GrpcCatalogo;
using Microsoft.AspNetCore.Mvc;

namespace Catalogo.API.Config
{
  public static class ApiConfig
  {
    public static IServiceCollection AddApiConfiguration(this IServiceCollection services, IConfiguration configuration)
    {
      bool isDevelopment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development";

      var authSettings = configuration.GetSection(nameof(AuthSettings));
      services.Configure<AuthSettings>(authSettings);
      services.AddResultFilter();
      services.AddDefaultHealthCheck().AddMongoHealthCheck(configuration);
      if (isDevelopment) services.AddDefaultHealthCheckUI();
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
      services.AddSingleton<FavoritoItemRepository>();
      services.AddSingleton<RatingItemRepository>();

      services.AddTransient<IProdutoRepository>(sp => sp.GetRequiredService<ProdutoRepository>());
      services.AddTransient<ICarrinhoItemRepository>(sp => sp.GetRequiredService<CarrinhoItemRepository>());
      services.AddTransient<IFavoritoItemRepository>(sp => sp.GetRequiredService<FavoritoItemRepository>());
      services.AddTransient<INotificacoesRepository>(sp => sp.GetRequiredService<NotificacoesRepository>());
      services.AddTransient<IFavoritoItemRepository>(sp => sp.GetRequiredService<FavoritoItemRepository>());

      services.AddAuthServices();

      services.Configure<ApiBehaviorOptions>(options =>
      {
        options.SuppressMapClientErrors = true;
        options.SuppressModelStateInvalidFilter = true;
      });
      services.AddUtils();

      services.AddGrpc();

      services.AddSingleton(configuration.BindSettings<EventBusSettings>(nameof(EventBusSettings)));

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
      app.MapGrpcService<CarrinhoService>();
      app.MapControllers();

      return app;
    }
  }
}
