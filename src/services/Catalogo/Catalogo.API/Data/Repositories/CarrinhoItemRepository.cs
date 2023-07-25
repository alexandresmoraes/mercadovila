using Catalogo.API.Data.Entities;
using Common.WebAPI.MongoDb;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Catalogo.API.Data.Repositories
{
  public class CarrinhoItemRepository : MongoService<CarrinhoItem>, ICarrinhoItemRepository
  {
    public CarrinhoItemRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
     : base(mongoClient, opt, "carrinho")
    {
      var indexKeysDefinition = Builders<CarrinhoItem>.IndexKeys
        .Text(_ => _.UserId)
        .Text(_ => _.ProdutoId);
      var indexOptions = new CreateIndexOptions { Unique = true };
      var indexModel = new CreateIndexModel<CarrinhoItem>(indexKeysDefinition, indexOptions);

      Collection.Indexes.CreateOne(indexModel);
    }
  }
}
