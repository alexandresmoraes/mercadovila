using MongoDB.Driver;

namespace Common.WebAPI.MongoDb
{
  public interface IMongoService<T>
  {
    public IMongoCollection<T> Collection { get; }
  }
}