using Common.WebAPI.MongoDb;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Catalogo.API.Data
{
  public class ProdutoService : MongoService<Produto>
  {
    public ProdutoService(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
      : base(mongoClient, opt, "produtos")
    {
      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        new IndexKeysDefinitionBuilder<Produto>()
        .Ascending(_ => _.Nome)
        .Ascending(_ => _.Preco)
      ));
    }
  }
}
