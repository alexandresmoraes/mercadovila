namespace Common.WebAPI.Results
{
  public interface IResultNotFound { }

  public record ResultNotFound(string message) : Result(message), IResultNotFound { }
  public record ResultNotFound<T>(string message) : Result<T>(message), IResultNotFound { }
}