using System.Text.Json.Serialization;

namespace Common.EventBus.Integrations.IntegrationEvents
{
  public record VendaCriadaIntegrationEvent : IntegrationEvent
  {
    public string UserId { get; private init; }
    public Dictionary<string, int> Itens { get; private init; }

    public VendaCriadaIntegrationEvent(string userId, Dictionary<string, int> itens)
    {
      UserId = userId;
      Itens = itens;
    }

    [JsonConstructor]
    public VendaCriadaIntegrationEvent(string userId, Dictionary<string, int> itens, string id, DateTimeOffset creationDate, string? key)
      : base(id, creationDate, key)
    {
      UserId = userId;
      Itens = itens;
    }
  }
}