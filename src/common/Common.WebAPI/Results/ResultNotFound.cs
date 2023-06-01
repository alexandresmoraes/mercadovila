namespace Common.WebAPI.Results
{
  public interface IResultNotFound { }

  public record ResultNotFound : Result, IResultNotFound
  {
    public ResultNotFound() { }

    public ResultNotFound(string message) : base(message) { }
  }
  public record ResultNotFound<T>(string message) : Result<T>(message), IResultNotFound { }
}