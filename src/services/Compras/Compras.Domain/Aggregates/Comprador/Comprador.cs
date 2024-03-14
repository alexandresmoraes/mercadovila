using Common.WebAPI.Shared;

namespace Compras.Domain.Aggregates
{
  public class Comprador : Entity, IAggregateRoot
  {
    public string UserId { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string Username { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string? FotoUrl { get; set; }

    public Comprador() { }

    public Comprador(string userId, string nome, string username, string email, string? fotoUrl)
    {
      UserId = userId;
      Nome = nome;
      Username = username;
      Email = email;
      FotoUrl = fotoUrl;
    }

    public override string ToString()
    {
      return $"Comprador {Id} / " +
        $"Nome {Nome} / " +
        $"Email {Email}";
    }
  }
}