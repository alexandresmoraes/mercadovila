namespace Common.WebAPI.Results
{
  public interface IResultNoContent { }

  public record ResultNoContent : Result, IResultNoContent { }
}
