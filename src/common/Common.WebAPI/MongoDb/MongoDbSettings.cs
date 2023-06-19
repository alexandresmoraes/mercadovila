namespace Common.WebAPI.MongoDb
{
  public record MongoDbSettings
  {
    public string DatabaseName { get; set; } = null!;
  }
}