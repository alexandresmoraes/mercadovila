using Common.WebAPI.Logs;
using Vendas.API.Config;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApiConfiguration(builder.Configuration);

builder.Services.AddAuthConfig(builder.Configuration);

builder.Logging.AddSerilog(builder.Configuration);
builder.Services.AddSerilog();

var app = builder.Build();

app.UseApiConfiguration();

app.Run();