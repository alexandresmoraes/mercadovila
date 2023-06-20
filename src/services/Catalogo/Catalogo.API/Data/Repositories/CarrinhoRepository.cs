using Catalogo.API.Data.Entities;
using Common.WebAPI.MongoDb;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Catalogo.API.Data.Repositories
{
  public class CarrinhoRepository : MongoService<Carrinho>, ICarrinhoRepository
  {
    public CarrinhoRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
     : base(mongoClient, opt, "carrinho")
    {
      var indexKeysDefinition = Builders<Carrinho>.IndexKeys.Text(_ => _.UserId);
      var indexOptions = new CreateIndexOptions { Unique = true };
      var indexModel = new CreateIndexModel<Carrinho>(indexKeysDefinition, indexOptions);

      Collection.Indexes.CreateOne(indexModel);
    }
  }
}
