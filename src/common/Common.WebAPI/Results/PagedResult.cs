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

    protected PagedResultBase(int start, int limit, long total)
    {
      Start = start;
      Limit = limit;
      Total = total;
    }
  }

  public record PagedResult<TDto> : PagedResultBase where TDto : class
  {
    public IList<TDto> Data { get; private set; }

    public PagedResult(int start, int limit, long total, IList<TDto> data)
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

    public PagedResultWithExtraDto(int start, int limit, long total, IList<TDto> data, TExtraDto dto)
                : base(start, limit, total, data)
    {
      Dto = dto ?? throw new ArgumentNullException(nameof(dto));
    }
  }
}
