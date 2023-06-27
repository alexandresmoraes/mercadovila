using MongoDB.Driver;

namespace Common.WebAPI.MongoDb
{
  public class UnitOfWork : IUnitOfWork
  {
    private readonly IMongoClient _mongoClient;
    private IClientSessionHandle? _session;
    private bool _isActive = false;

    public UnitOfWork(IMongoClient mongoClient)
      => _mongoClient = mongoClient ?? throw new ArgumentNullException(nameof(mongoClient));

    public async Task BeginTransactionAsync(CancellationToken cancellationToken = default)
    {
      _session = await _mongoClient.StartSessionAsync(cancellationToken: cancellationToken);
      _session.StartTransaction();
      _isActive = true;
    }

    public async Task CommitTransactionAsync(CancellationToken cancellationToken = default)
    {
      await _session!.CommitTransactionAsync(cancellationToken);
      _isActive = false;
    }

    public async Task AbortTransactionAsync(CancellationToken cancellationToken = default)
    {
      if (_isActive)
      {
        await _session!.AbortTransactionAsync(cancellationToken);
        _isActive = false;
      }
    }

    public bool IsActive { get => _isActive; }

    public void Dispose()
    {
      _session?.Dispose();
    }
  }
}
