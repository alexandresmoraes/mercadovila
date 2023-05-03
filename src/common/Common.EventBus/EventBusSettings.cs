namespace Common.EventBus
{
  public record EventBusSettings
  {
    public string BootstrapServer { get; set; } = null!;
    public string Topic { get; set; } = null!;
    public string Group { get; set; } = null!;
  }
}