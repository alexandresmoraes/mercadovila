using Common.EventBus.Integrations.IntegrationEvents;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json;

namespace Common.EventBus.Integrations
{
  public class IntegrationEventLog
  {
    private IntegrationEventLog() { }

    public IntegrationEventLog(IntegrationEvent @event, string transactionId)
    {
      EventId = @event.Id;
      CreationTime = @event.CreationDate;
      EventTypeName = @event.GetType().FullName!;
      Content = JsonSerializer.Serialize(@event, @event.GetType(), new JsonSerializerOptions
      {
        WriteIndented = true
      });
      State = EnumEventState.NotPublished;
      TimesSent = 0;
      TransactionId = transactionId;
    }
    public string EventId { get; private set; } = null!;
    public string EventTypeName { get; private set; } = null!;
    [NotMapped]
    public string? EventTypeShortName => EventTypeName.Split('.')?.Last();
    [NotMapped]
    public IntegrationEvent IntegrationEvent { get; private set; } = null!;
    public EnumEventState State { get; set; }
    public int TimesSent { get; set; }
    public DateTime CreationTime { get; private set; }
    public string Content { get; private set; } = null!;
    public string TransactionId { get; private set; } = null!;

    public IntegrationEventLog DeserializeJsonContent(Type type)
    {
      IntegrationEvent = (JsonSerializer.Deserialize(Content, type, new JsonSerializerOptions()
      {
        PropertyNameCaseInsensitive = true
      }) as IntegrationEvent)!;

      return this;
    }
  }
}
