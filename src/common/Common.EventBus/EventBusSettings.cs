namespace Common.EventBus
{
  public record EventBusSettings
  {
    public string BootstrapServer { get; set; } = null!;
    public string? Topic { get; set; }
    public string? Group { get; set; }
  }
}