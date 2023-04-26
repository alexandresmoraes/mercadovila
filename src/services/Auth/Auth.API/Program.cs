using Auth.API.Config;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApiConfiguration(builder.Configuration);
builder.Services.AddIdentityConfiguration();

var app = builder.Build();

app.UseApiConfiguration();

app.Run();
