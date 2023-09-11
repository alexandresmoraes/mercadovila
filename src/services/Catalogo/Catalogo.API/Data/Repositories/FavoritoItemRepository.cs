using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Queries;
using Common.WebAPI.MongoDb;
using Common.WebAPI.Results;
using Microsoft.Extensions.Options;
using MongoDB.Bson;
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

    public async Task CreateAsync(string userId, string produtoId)
    {
      var favorito = new FavoritoItem()
      {
        UserId = userId,
        ProdutoId = produtoId
      };

      await Collection.InsertOneAsync(favorito);
    }

    public async Task<bool> DeleteAsync(string userId, string produtoId)
    {
      var filter = Builders<FavoritoItem>.Filter.Eq(_ => _.UserId, userId);
      filter &= Builders<FavoritoItem>.Filter.Eq(_ => _.ProdutoId, produtoId);

      var result = await Collection.DeleteOneAsync(filter);

      return result.DeletedCount > 0;
    }

    public async Task<bool> ExisteFavoritoPorUserId(string userId, string produtoId)
    {
      var filtro = Builders<FavoritoItem>.Filter.Eq(_ => _.UserId, userId);
      filtro &= Builders<FavoritoItem>.Filter.Eq(_ => _.ProdutoId, produtoId);

      var count = await Collection.CountDocumentsAsync(filtro);

      return count > 0;
    }

    public async Task<PagedResult<FavoritoItemDto>> GetFavoritosAsync(FavoritoItemQuery query, string userId)
    {
      var start = (query.page - 1) * query.limit;

      var lookupStage = new BsonDocument("$lookup",
        new BsonDocument
        {
          { "from", "produtos" },
          { "localField", "ProdutoId" },
          { "foreignField", "_id" },
          { "as", "produto" }
        });

      var unwindStage = new BsonDocument("$unwind", "$produto");

      var matchStage = new BsonDocument
      {
        {
          "$match",
          new BsonDocument
          {
            { "UserId", userId }
          }
       }
      };

      var projectStage = new BsonDocument("$project",
        new BsonDocument
        {
          { "ProdutoId", "$ProdutoId" },
          { "Nome", "$produto.Nome" },
          { "Descricao", "$produto.Descricao" },
          { "ImageUrl", "$produto.ImageUrl" },
          { "Preco", "$produto.Preco" },
          { "UnidadeMedida", "$produto.UnidadeMedida" },
          { "Estoque", "$produto.Estoque" },
          { "Rating", "$produto.Rating" },
          { "RatingCount", "$produto.RatingCount" },
          { "IsAtivo", "$produto.IsAtivo" },
        });

      var pipeline = new[] { lookupStage, unwindStage, matchStage, projectStage };

      var aggregation = await Collection.Aggregate<FavoritoItemDto>(pipeline).ToListAsync();

      var count = await Collection.CountDocumentsAsync(Builders<FavoritoItem>.Filter.Eq(_ => _.UserId, userId));

      return new PagedResult<FavoritoItemDto>(start, query.limit, count, aggregation);
    }
  }
}