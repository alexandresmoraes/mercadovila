using Catalogo.API.Data.Entities;
using Common.WebAPI.MongoDb;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Catalogo.API.Data.Repositories
{
  public class FavoritosRepository : MongoService<Favoritos>, IFavoritosRepository
  {
    public FavoritosRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
     : base(mongoClient, opt, "favoritos")
    {
      var indexKeysDefinition = Builders<Favoritos>.IndexKeys
        .Text(_ => _.UserId)
        .Text(_ => _.ProdutoId);
      var indexOptions = new CreateIndexOptions { Unique = true };
      var indexModel = new CreateIndexModel<Favoritos>(indexKeysDefinition, indexOptions);

      Collection.Indexes.CreateOne(indexModel);
    }
  }
}