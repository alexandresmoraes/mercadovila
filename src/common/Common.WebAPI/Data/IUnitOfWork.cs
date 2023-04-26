using Microsoft.EntityFrameworkCore;

namespace Common.WebAPI.Data
{
  public interface IUnitOfWork<TDbContext> where TDbContext : DbContext
  {
    public Task BeginTransactionAsync(CancellationToken cancellationToken = default);
    public Task CommitAsync(CancellationToken cancellationToken = default);
    public Task RollbackAsync(CancellationToken cancellationToken = default);
  }
}