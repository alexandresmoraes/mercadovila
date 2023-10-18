using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Common.WebAPI.MongoDb;
using Microsoft.Extensions.Options;
using MongoDB.Bson;
using MongoDB.Driver;

namespace Catalogo.API.Data.Repositories
{
  public class CarrinhoItemRepository : MongoService<CarrinhoItem>, ICarrinhoItemRepository
  {
    public CarrinhoItemRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
     : base(mongoClient, opt, "carrinho")
    {
      var indexKeysDefinition = Builders<CarrinhoItem>.IndexKeys
        .Ascending(_ => _.UserId)
        .Ascending(_ => _.ProdutoId);
      var indexOptions = new CreateIndexOptions { Unique = true };
      var indexModel = new CreateIndexModel<CarrinhoItem>(indexKeysDefinition, indexOptions);

      Collection.Indexes.CreateOne(indexModel);
    }

    public async Task AdicionarAsync(string userId, string produtoId, int quantidade)
    {
      var filter = Builders<CarrinhoItem>.Filter.And(
            Builders<CarrinhoItem>.Filter.Eq(x => x.UserId, userId),
            Builders<CarrinhoItem>.Filter.Eq(x => x.ProdutoId, produtoId)
      );

      var update = Builders<CarrinhoItem>
        .Update.Inc(x => x.Quantidade, quantidade);

      var result = await Collection.UpdateOneAsync(filter, update);

      if (result.ModifiedCount == 0)
      {
        var carrinhoItem = new CarrinhoItem
        {
          UserId = userId,
          ProdutoId = produtoId,
          Quantidade = quantidade
        };

        await Collection.InsertOneAsync(carrinhoItem);
      }
    }

    public async Task<CarrinhoDto> GetCarrinhoPorUsuarioAsync(string userId)
    {
      var pipeline = new BsonDocument[]
        {
            new BsonDocument("$lookup",
              new BsonDocument
              {
                { "from", "produtos" },
                { "localField", "ProdutoId" },
                { "foreignField", "_id" },
                { "as", "produto" }
              }),
            new BsonDocument("$unwind", "$produto"),

            new BsonDocument("$lookup", new BsonDocument
                {
                  { "from", "favoritos" },
                  { "let", new BsonDocument("produtoId", "$ProdutoId") },
                  { "pipeline", new BsonArray
                  {
                    new BsonDocument("$match", new BsonDocument
                    {
                      { "$expr", new BsonDocument("$and", new BsonArray
                        {
                          new BsonDocument("$eq", new BsonArray { "$ProdutoId", "$$produtoId" }),
                          new BsonDocument("$eq", new BsonArray { "$UserId", userId })
                        })
                      }
                    })
                }
              },
              { "as", "Favoritos" }
            }),

            new BsonDocument("$match",
              new BsonDocument
                {
                    {
                        "Quantidade",
                        new BsonDocument("$gt", 0)
                    },
                    {
                        "UserId",
                        userId
                    }
                }),

            new BsonDocument("$project",
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
                { "Quantidade", "$Quantidade" },
                { "IsFavorito", new BsonDocument("$cond", new BsonArray
                    {
                        new BsonDocument("$gt", new BsonArray { new BsonDocument("$size", "$Favoritos"), 0 }),
                        true,
                        false
                    })
                }
              })
        };

      var aggregation = await Collection.Aggregate<CarrinhoItemDto>(pipeline).ToListAsync();

      return new CarrinhoDto(aggregation);
    }

    public async Task<int> GetQuantidadeCarrinhoItem(string userId, string produtoId)
    {
      var filter = Builders<CarrinhoItem>.Filter.And(
            Builders<CarrinhoItem>.Filter.Eq(x => x.UserId, userId),
            Builders<CarrinhoItem>.Filter.Eq(x => x.ProdutoId, produtoId)
      );

      var projection = Builders<CarrinhoItem>.Projection.Include(x => x.Quantidade);

      var result = await Collection.Find(filter).Project<BsonDocument>(projection)
        .FirstOrDefaultAsync();

      if (result is not null)
      {
        if (result.TryGetValue("Quantidade", out var quantidadeValue) && quantidadeValue.IsInt32)
        {
          return quantidadeValue.AsInt32;
        }
      }

      return 0;
    }

    public async Task RemoverAsync(string userId, string produtoId, int quantidade)
    {
      var filter = Builders<CarrinhoItem>.Filter.And(
            Builders<CarrinhoItem>.Filter.Eq(x => x.UserId, userId),
            Builders<CarrinhoItem>.Filter.Eq(x => x.ProdutoId, produtoId)
      );

      var update = Builders<CarrinhoItem>
        .Update.Inc(x => x.Quantidade, -quantidade);

      await Collection.UpdateOneAsync(filter, update);
    }

    public async Task RemoverCarrinhoPorUsuarioAsync(string userId)
    {
      var filter = Builders<CarrinhoItem>.Filter.Eq(x => x.UserId, userId);

      await Collection.DeleteOneAsync(filter);
    }
  }
}