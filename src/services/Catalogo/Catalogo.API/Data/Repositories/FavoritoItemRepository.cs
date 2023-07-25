using Catalogo.API.Data.Entities;
using Common.WebAPI.MongoDb;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Catalogo.API.Data.Repositories
{
  public class FavoritoItemRepository : MongoService<FavoritoItem>, IFavoritoItemRepository
  {
    public FavoritoItemRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
     : base(mongoClient, opt, "favoritos")
    {
      var indexKeysDefinition = Builders<FavoritoItem>.IndexKeys
        .Text(_ => _.UserId)
        .Text(_ => _.ProdutoId);
      var indexOptions = new CreateIndexOptions { Unique = true };
      var indexModel = new CreateIndexModel<FavoritoItem>(indexKeysDefinition, indexOptions);

      Collection.Indexes.CreateOne(indexModel);
    }
  }
}