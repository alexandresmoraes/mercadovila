using Common.WebAPI.Shared;
using System.Text.Json;

namespace Vendas.Domain.Aggregates
{
  public class Comprador : Entity, IAggregateRoot
  {
    public string UserId { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string? FotoUrl { get; set; }

    public Comprador() { }

    public Comprador(string userId, string nome, string? fotoUrl)
    {
      UserId = userId;
      Nome = nome;
      FotoUrl = fotoUrl;
    }

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}