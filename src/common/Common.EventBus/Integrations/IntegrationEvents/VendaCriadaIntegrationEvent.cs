namespace Common.EventBus.Integrations.IntegrationEvents
{
  public record VendaCriadaIntegrationEvent : IntegrationEvent
  {
    public string UserId { get; init; }

    public VendaCriadaIntegrationEvent(string userId)
        => UserId = userId;
  }
}