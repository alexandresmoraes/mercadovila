using Catalogo.API.Config;
using Common.WebAPI.Logs;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApiConfiguration(builder.Configuration);

builder.Services.AddAuthConfig(builder.Configuration);

builder.Logging.AddSerilog(builder.Configuration);

var app = builder.Build();

app.UseApiConfiguration();

app.Run();