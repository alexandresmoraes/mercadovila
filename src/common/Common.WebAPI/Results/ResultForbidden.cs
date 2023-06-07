namespace Common.WebAPI.Results
{
  public interface IResultForbidden { }

  public record ResultForbidden : Result, IResultForbidden { }
  public record ResultForbidden<T>() : Result<T>(), IResultForbidden { }
}
