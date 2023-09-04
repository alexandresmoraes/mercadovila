using Catalogo.API.Config;
using Catalogo.API.Data.Repositories;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.Logs;
using Common.WebAPI.MongoDb;
using Common.WebAPI.Results;
using Common.WebAPI.WebApi;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.UseMongoDb(builder.Configuration);
builder.Services.AddDefaultHealthCheck().AddMongoHealthCheck(builder.Configuration);
builder.Services.AddDefaultHealthCheckUI();
builder.Services.AddOpenApi();
builder.Services.AddResultFilter();
builder.Services.Configure<ApiBehaviorOptions>(options =>
{
  options.SuppressMapClientErrors = true;
});

builder.Services.AddMvc(opt =>
{
#if DEBUG
  opt.Filters.Add<DelayDebugAttribute>();
#endif
});

builder.Services.AddScoped<ProdutoRepository>();
builder.Services.AddScoped<CarrinhoItemRepository>();
builder.Services.AddScoped<FavoritoItemRepository>();
builder.Services.AddAuthConfig(builder.Configuration);

builder.Logging.AddSerilog(builder.Configuration);

var app = builder.Build();

app.UseApiConfiguration();

app.Run();