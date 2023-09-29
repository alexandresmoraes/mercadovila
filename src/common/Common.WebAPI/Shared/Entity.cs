using MediatR;

namespace Common.WebAPI.Shared
{
  public abstract class Entity
  {
    int? _requestedHashCode;
    int _Id;
    public virtual int Id
    {
      get
      {
        return _Id;
      }
      protected set
      {
        _Id = value;
      }
    }

    private List<INotification> _domainEvents = new List<INotification>();
    public IReadOnlyCollection<INotification> DomainEvents => _domainEvents.AsReadOnly();

    public void AddDomainEvent(INotification eventItem)
    {
      _domainEvents.Add(eventItem);
    }

    public void RemoveDomainEvent(INotification eventItem)
    {
      _domainEvents.Remove(eventItem);
    }

    public void ClearDomainEvents()
    {
      _domainEvents.Clear();
    }

    public bool IsTransient()
    {
      return this.Id == default;
    }

    public override bool Equals(object? obj)
    {
      if (obj == null || obj is not Entity)
        return false;

      if (ReferenceEquals(this, obj))
        return true;

      if (GetType() != obj.GetType())
        return false;

      Entity item = (Entity)obj;

      if (item.IsTransient() || IsTransient())
        return false;
      else
        return item.Id == Id;
    }

    public override int GetHashCode()
    {
      if (!IsTransient())
      {
        if (!_requestedHashCode.HasValue)
          _requestedHashCode = Id.GetHashCode() ^ 31;

        return _requestedHashCode.Value;
      }
      else
        return base.GetHashCode();
    }
    public static bool operator ==(Entity left, Entity right)
    {
      if (Equals(left, null))
        return Equals(right, null) ? true : false;
      else
        return left.Equals(right);
    }

    public static bool operator !=(Entity left, Entity right)
    {
      return !(left == right);
    }
  }
}