using Auth.API.Config;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApiConfiguration(builder.Configuration);
builder.Services.AddAuthConfig(builder.Configuration);



var app = builder.Build();

app.UseApiConfiguration();

app.Run();
