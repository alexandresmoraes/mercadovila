namespace Common.EventBus.Integrations
{
  public abstract class Event
  {
    public string MessageType { get; protected set; }
    public string AggregateId { get; protected set; }
    public DateTime CreatedAt { get; set; }

    protected Event(string aggregateId)
    {
      MessageType = GetType().Name;
      AggregateId = aggregateId;
      CreatedAt = DateTime.Now;
    }
  }
}
