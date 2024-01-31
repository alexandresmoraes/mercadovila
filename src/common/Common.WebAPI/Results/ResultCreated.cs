namespace Common.WebAPI.Results
{
  public interface IResultCreated
  {
    public string Location { get; }
  }

  public record ResultCreated<T> : Result<T>, IResultCreated
  {
    public string Location { get; private set; }

    public ResultCreated(string location, T data) : base(data)
    {
      Location = location;
    }
  }
}
