using System.Text.Json.Serialization;

namespace Common.EventBus.Integrations.IntegrationEvents
{
  public record IntegrationEvent
  {
    public IntegrationEvent()
    {
      Id = Guid.NewGuid().ToString();
      CreationDate = DateTimeOffset.UtcNow;
    }

    [JsonConstructor]
    public IntegrationEvent(string id, DateTimeOffset creationDate, string? key)
    {
      Id = id;
      CreationDate = creationDate;
      Key = key;
    }

    [JsonInclude]
    public string Id { get; private init; }

    [JsonInclude]
    public DateTimeOffset CreationDate { get; private init; }

    [JsonInclude]
    public string? Key { get; private init; }
  }
}