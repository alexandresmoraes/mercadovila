namespace Common.WebAPI.Results
{
  public interface IResultNotFound { }

  public record ResultNotFound<T> : Result<T>, IResultNotFound { }
}