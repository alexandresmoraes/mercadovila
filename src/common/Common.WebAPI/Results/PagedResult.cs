namespace Common.WebAPI.Results
{
  public abstract record PagedResultBase
  {
    public int CurrentPage
    {
      get { return Start == 0 || Limit == 0 ? 1 : Start / Limit + 1; }
    }
    public long Total { get; set; }
    public int Start { get; set; }
    public int Limit { get; set; }

    public int FirstRowOnPage
    {
      get { return (CurrentPage - 1) * Start + 1; }
    }

    public int LastRowOnPage
    {
      get { return Convert.ToInt32(Math.Min(Convert.ToInt64((CurrentPage * Limit)), Total)); }
    }

    protected PagedResultBase(int start, int limit, long total)
    {
      Start = start;
      Limit = limit;
      Total = total;
    }
  }

  public record PagedResult<T> : PagedResultBase where T : class
  {
    public IList<T> Data { get; set; }

    public PagedResult(int start, int limit, long total, IList<T> data)
                : base(start, limit, total)
    {
      Data = data ?? throw new ArgumentNullException(nameof(data));
    }
  }

  public record PagedResultWithDto<T, TDto> : PagedResult<T>
    where T : class
    where TDto : class
  {
    public TDto Dto { get; set; }

    public PagedResultWithDto(int start, int limit, long total, IList<T> data, TDto dto)
                : base(start, limit, total, data)
    {
      Data = data ?? throw new ArgumentNullException(nameof(data));
      Dto = dto ?? throw new ArgumentNullException(nameof(dto));
    }
  }
}
