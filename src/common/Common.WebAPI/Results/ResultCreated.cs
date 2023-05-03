namespace Common.WebAPI.Results
{
  public interface IResultCreated { }

  public record ResultCreated<T>(T data) : Result<T>(data), IResultCreated { }
}
