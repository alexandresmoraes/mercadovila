using Catalogo.API.Config;
using Catalogo.API.Data.Repositories;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.Logs;
using Common.WebAPI.MongoDb;
using Common.WebAPI.Results;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.UseMongoDb(builder.Configuration);
builder.Services.AddDefaultHealthCheck().AddMongoHealthCheck(builder.Configuration);
builder.Services.AddDefaultHealthCheckUI();
builder.Services.AddOpenApi();
builder.Services.AddResultFilter();

builder.Services.AddScoped<ProdutoRepository>();
builder.Services.AddScoped<CarrinhoItemRepository>();
builder.Services.AddScoped<FavoritoItemRepository>();

builder.Logging.AddSerilog(builder.Configuration);

var app = builder.Build();

app.MapHealthChecks();
if (app.Environment.IsDevelopment())
{
  app.UseOpenApi();
  app.MapHealthChecksUI();
}

app.UseAuthorization();
app.MapControllers();

app.Run();