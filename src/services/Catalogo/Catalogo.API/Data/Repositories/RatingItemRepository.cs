using Catalogo.API.Data.Entities;
using Common.WebAPI.MongoDb;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Catalogo.API.Data.Repositories
{
  public class RatingItemRepository : MongoService<RatingItem>, IRatingItemRepository
  {
    public RatingItemRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
      : base(mongoClient, opt, "ratings")
    {
      var indexKeysDefinition = Builders<RatingItem>.IndexKeys
        .Ascending(_ => _.VendaId)
        .Ascending(_ => _.ProdutoId);
      var indexOptions = new CreateIndexOptions { Unique = true };
      var indexModel = new CreateIndexModel<RatingItem>(indexKeysDefinition, indexOptions);

      Collection.Indexes.CreateOne(indexModel);
    }

    public async Task AdicionarAsync(RatingItem rating) => await Collection.InsertOneAsync(rating);

    public async Task AtualizarAsync(RatingItem rating)
      => await Collection.ReplaceOneAsync(r => r.Id == rating.Id, rating);

    public async Task<RatingItem?> GetRatingPorVendaEProduto(long vendaId, string produtoId)
    {
      var filtro = Builders<RatingItem>.Filter.Eq(r => r.VendaId, vendaId);
      filtro &= Builders<RatingItem>.Filter.Eq(r => r.ProdutoId, produtoId);

      var ratingItem = await Collection.Find(filtro)
        .SingleOrDefaultAsync();

      return ratingItem;
    }

    public async Task<short> RatingPorVendaEProduto(long vendaId, string produtoId)
    {
      var ratingItem = await GetRatingPorVendaEProduto(vendaId, produtoId);
      return ratingItem?.Rating ?? 0;
    }
  }
}
