using Common.WebAPI.Shared;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;

namespace Common.WebAPI.PostgreSql
{
  public class UnitOfWork : IUnitOfWork, IDisposable
  {
    private readonly DbContext _context;
    private IDbContextTransaction? _transaction;
    private bool _isActive = false;

    public UnitOfWork(DbContext context)
      => _context = context ?? throw new ArgumentNullException(nameof(context));

    public async Task BeginTransactionAsync(CancellationToken cancellationToken = default)
    {
      _transaction = await _context.Database.BeginTransactionAsync(cancellationToken);
      _isActive = true;
    }

    public async Task CommitAsync(CancellationToken cancellationToken = default)
    {
      await _transaction!.CommitAsync(cancellationToken);
      _isActive = false;
    }

    public async Task RollbackAsync(CancellationToken cancellationToken = default)
    {
      if (_isActive)
      {
        await _transaction!.RollbackAsync(cancellationToken);
        _isActive = false;
      }
    }

    public bool HasActiveTransaction { get => _isActive; }

    public void Dispose()
    {
      _transaction?.Dispose();
      _context?.Dispose();
    }

    public TTransaction GetTransaction<TTransaction>() => (TTransaction)_context.Database.CurrentTransaction!;

    public IEnumerable<Entity> GetEntitiesPersistenceContext()
    {
      return _context.ChangeTracker
        .Entries<Entity>()
        .Select(_ => _.Entity);
    }
  }
}