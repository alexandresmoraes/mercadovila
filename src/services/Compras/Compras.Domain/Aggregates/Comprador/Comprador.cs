using Common.WebAPI.Shared;

namespace Compras.Domain.Aggregates
{
  public class Comprador : Entity, IAggregateRoot
  {
    public string UserId { get; private set; } = null!;
    public string Nome { get; private set; } = null!;
    public string Username { get; private set; } = null!;
    public string Email { get; private set; } = null!;
    public string? FotoUrl { get; private set; }

    public Comprador() { }

    public Comprador(string userId, string nome, string username, string email, string? fotoUrl)
    {
      UserId = userId;
      Nome = nome;
      Username = username;
      Email = email;
      FotoUrl = fotoUrl;
    }

    public void Atualizar(string nome, string username, string email, string? fotoUrl)
    {
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