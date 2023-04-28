using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;

namespace Common.WebAPI.Data
{
  public class UnitOfWork<TDbContext> : IUnitOfWork<TDbContext>, IDisposable
    where TDbContext : DbContext
  {
    private readonly TDbContext _context;
    private IDbContextTransaction? _transaction;
    private bool _isActive = false;

    public UnitOfWork(TDbContext context)
      => _context = context ?? throw new ArgumentNullException(nameof(context));

    public async Task BeginTransactionAsync(CancellationToken cancellationToken = default)
    {
      _isActive = true;
      _transaction = await _context.Database.BeginTransactionAsync(cancellationToken);
    }

    public Task CommitAsync(CancellationToken cancellationToken = default)
    {
      _isActive = false;
      return _transaction!.CommitAsync(cancellationToken);
    }

    public Task RollbackAsync(CancellationToken cancellationToken = default)
    {
      _isActive = false;
      return _transaction!.RollbackAsync(cancellationToken);
    }

    public bool IsActive { get => _isActive; }

    public void Dispose()
    {
      _transaction?.Dispose();
      _context?.Dispose();
    }
  }
}