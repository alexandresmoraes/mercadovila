using Common.Grpc;
using Common.WebAPI.Logs;
using GrpcVendas;
using Vendas.API.Config;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApiConfiguration(builder.Configuration);

builder.Services.AddAuthConfig(builder.Configuration);

builder.Logging.AddSerilog(builder.Configuration);
builder.Services.AddSerilog();


builder.Services.AddTransient<GrpcExceptionInterceptor>();

builder.Services.AddGrpcClient<Catalogo.CatalogoClient>((services, options) =>
{
  var grpcUrl = builder.Configuration.GetSection("CatalogoUrlGrpc").Value;
  options.Address = new Uri(grpcUrl);
}).AddInterceptor<GrpcExceptionInterceptor>();

var app = builder.Build();

app.UseApiConfiguration();

app.Run();