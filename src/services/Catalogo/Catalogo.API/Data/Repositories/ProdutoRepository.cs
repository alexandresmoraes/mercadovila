using Catalogo.API.Data.Entities;
using Common.WebAPI.MongoDb;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Catalogo.API.Data.Repositories
{
  public class ProdutoRepository : MongoService<Produto>, IProdutoRepository
  {
    public ProdutoRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
     : base(mongoClient, opt, "produtos")
    {
      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Ascending(_ => _.Nome),
        new CreateIndexOptions { Unique = true }
      ));

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Descending(_ => _.Nome)
      ));

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Descending(_ => _.DataUltimaCompra)
      ));

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Descending(_ => _.DataCriacao)
      ));

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Ascending(_ => _.Rating)
      ));

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Descending(_ => _.Rating)
      ));
    }
  }
}
