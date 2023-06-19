using Catalogo.API.Config;
using Catalogo.API.Data;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.Logs;
using Common.WebAPI.MongoDb;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.UseMongoDb(builder.Configuration);
builder.Services.AddDefaultHealthCheck().AddMongoHealthCheck(builder.Configuration);
builder.Services.AddDefaultHealthCheckUI();
builder.Services.AddOpenApi();
builder.Services.AddScoped<ProdutoService>();

builder.Logging.AddSerilog(builder.Configuration);

var app = builder.Build();

app.MapHealthChecks();
if (app.Environment.IsDevelopment())
{
  app.UseOpenApi();
  app.MapHealthChecksUI();
}
else
{
  app.UseHttpsRedirection();
}


app.UseAuthorization();
app.MapControllers();

app.Run();
