using Common.EventBus.HealtCheck;
using Common.WebAPI.HealthCheck;
using Common.WebAPI.Logs;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.AddSerilog(builder.Configuration);
builder.Services.AddSerilog();

var healthCheckBuilder = builder.Services.AddHealthChecksUI(setupSettings: setup =>
{
  setup.SetHeaderText("MercadoVila - Status Page");
  var endpoints = builder.Configuration.GetSection("HealthChecks").Get<List<string>>();

  foreach (var endpoint in endpoints)
  {
    var name = endpoint.Split(';')[0];
    var uri = endpoint.Split(';')[1];

    setup.AddHealthCheckEndpoint(name, uri);
  }
});

builder.Services.AddHealthCheckKafka(builder.Configuration.GetConnectionString("Kafka"));

healthCheckBuilder.AddInMemoryStorage();

var app = builder.Build();

app.MapHealthChecks();

app.MapHealthChecksUI(setup =>
{
  setup.AddCustomStylesheet("site.css");
  setup.UIPath = "/";
  setup.PageTitle = "MercadoVila - Status Page";
});
app.Run();