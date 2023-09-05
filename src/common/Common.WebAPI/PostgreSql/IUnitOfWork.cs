﻿namespace Common.WebAPI.PostgreSql
{
  public interface IUnitOfWork
  {
    public Task BeginTransactionAsync(CancellationToken cancellationToken = default);
    public Task CommitAsync(CancellationToken cancellationToken = default);
    public Task RollbackAsync(CancellationToken cancellationToken = default);
    public bool IsActive { get; }
  }
}