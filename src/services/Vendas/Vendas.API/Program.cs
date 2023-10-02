using Common.WebAPI.PostgreSql;
using Microsoft.EntityFrameworkCore;
using Vendas.Infra.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<ApplicationDbContext>();
builder.Services.AddScoped<DbContext, ApplicationDbContext>();
builder.Services.AddUnitOfWorkPostgres();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
  app.UseSwagger();
  app.UseSwaggerUI();
}

app.RunMigrations<ApplicationDbContext>();
app.UseAuthorization();
app.MapControllers();

app.Run();