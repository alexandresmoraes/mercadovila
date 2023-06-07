namespace Common.WebAPI.Results
{
  public interface IResultUnauthorized { }

  public record ResultUnauthorized : Result, IResultUnauthorized { }
  public record ResultUnauthorized<T>() : Result<T>(), IResultUnauthorized { }
}
