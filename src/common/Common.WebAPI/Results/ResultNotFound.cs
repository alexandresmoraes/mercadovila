namespace Common.WebAPI.Results
{
  public interface IResultNotFound { }

  public class ResultNotFound<T> : Result<T>, IResultNotFound { }
}