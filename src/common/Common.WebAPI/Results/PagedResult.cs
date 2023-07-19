namespace Common.WebAPI.Results
{
  public abstract record PagedResultBase
  {
    public int CurrentPage
    {
      get { return Start == 0 || Limit == 0 ? 1 : Start / Limit + 1; }
    }
    public long Total { get; private set; }
    public int Start { get; private set; }
    public int Limit { get; private set; }
    public int TotalPages { get; private set; }
    public bool HasPreviousPage => CurrentPage > 1;
    public bool HasNextPage => CurrentPage < TotalPages;
    public int FirstRowOnPage
    {
      get
      {
        return (CurrentPage - 1) * Start + 1;
      }
    }

    public int LastRowOnPage
    {
      get
      {
        return Convert.ToInt32(Math.Min(Convert.ToInt64(CurrentPage * Limit), Total));
      }
    }


    protected PagedResultBase(int start, int limit, long total)
    {
      Start = start;
      Limit = limit;
      Total = total;

      TotalPages = Convert.ToInt32(Math.Ceiling(total / (double)limit));
    }
  }

  public record PagedResult<TDto> : PagedResultBase where TDto : class
  {
    public IEnumerable<TDto> Data { get; private set; }

    public PagedResult(int start, int limit, long total, IEnumerable<TDto> data)
      : base(start, limit, total)
    {
      Data = data ?? throw new ArgumentNullException(nameof(data));
    }
  }

  public record PagedResultWithExtraDto<TDto, TExtraDto> : PagedResult<TDto>
    where TDto : class
    where TExtraDto : class
  {
    public TExtraDto Dto { get; private set; }

    public PagedResultWithExtraDto(int start, int limit, long total, IEnumerable<TDto> data, TExtraDto dto)
      : base(start, limit, total, data)
    {
      Dto = dto ?? throw new ArgumentNullException(nameof(dto));
    }
  }
}
