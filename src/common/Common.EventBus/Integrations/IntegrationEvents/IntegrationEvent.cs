using System.Text.Json.Serialization;

namespace Common.EventBus.Integrations.IntegrationEvents
{
  public record IntegrationEvent
  {
    public IntegrationEvent()
    {
      Id = Guid.NewGuid().ToString();
      CreationDate = DateTime.UtcNow;
    }

    [JsonConstructor]
    public IntegrationEvent(string id, DateTime createDate)
    {
      Id = id;
      CreationDate = createDate;
    }

    [JsonInclude]
    public string Id { get; private init; }

    [JsonInclude]
    public DateTime CreationDate { get; private init; }

    [JsonInclude]
    public string? Key { get; private init; }
  }
}