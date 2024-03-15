using System.Text.Json.Serialization;

namespace Common.EventBus.Integrations.IntegrationEvents
{
  public record UsuarioAlteradoIntegrationEvent : IntegrationEvent
  {
    public string UserId { get; private init; }
    public string Nome { get; private init; }
    public string Username { get; private init; }
    public string Email { get; private init; }

    public string? FotoUrl { get; private init; }

    public UsuarioAlteradoIntegrationEvent(string userId, string nome, string username, string email, string? fotoUrl)
    {
      UserId = userId;
      Nome = nome;
      Username = username;
      Email = email;
      FotoUrl = fotoUrl;
    }

    [JsonConstructor]
    public UsuarioAlteradoIntegrationEvent(string userId, string nome, string username, string email, string? fotoUrl, string id, DateTimeOffset creationDate, string? key)
      : base(id, creationDate, key)
    {
      UserId = userId;
      Nome = nome;
      Username = username;
      Email = email;
      FotoUrl = fotoUrl;
    }
  }
}