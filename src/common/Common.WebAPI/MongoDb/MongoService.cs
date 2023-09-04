using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Common.WebAPI.MongoDb
{
  public abstract class MongoService<T>
  {
    private readonly IMongoClient _mongoClient;
    private readonly IMongoDatabase _database;
    private readonly string _collectionName;

    protected MongoService(IMongoClient mongoClient, IOptions<MongoDbSettings> opt, string collectionName)
    {
      _mongoClient = mongoClient;
      _database = _mongoClient.GetDatabase(opt.Value.DatabaseName);
      _collectionName = collectionName;
    }

    protected IMongoCollection<T> Collection => _database.GetCollection<T>(_collectionName);
  }
}
