namespace Common.WebAPI.MongoDb
{
  public interface IUnitOfWork
  {
    public Task BeginTransactionAsync(CancellationToken cancellationToken = default);
    public Task CommitTransactionAsync(CancellationToken cancellationToken = default);
    public Task AbortTransactionAsync(CancellationToken cancellationToken = default);
    public bool IsActive { get; }
  }
}