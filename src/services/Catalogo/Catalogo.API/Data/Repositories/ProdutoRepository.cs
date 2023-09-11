﻿using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Queries;
using Common.WebAPI.MongoDb;
using Common.WebAPI.Results;
using Microsoft.Extensions.Options;
using MongoDB.Bson;
using MongoDB.Driver;
using System.Text.RegularExpressions;

namespace Catalogo.API.Data.Repositories
{
  public class ProdutoRepository : MongoService<Produto>, IProdutoRepository
  {
    private FavoritoItemRepository _favoriteItemRepository;

    public ProdutoRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt, FavoritoItemRepository favoriteItemRepository)
     : base(mongoClient, opt, "produtos")
    {
      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Ascending(_ => _.Nome),
        new CreateIndexOptions { Unique = true }
      ));

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Ascending(_ => _.CodigoBarras),
        new CreateIndexOptions { Unique = true }
      ));

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Descending(_ => _.Nome)
      ));

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Descending(_ => _.DataUltimaVenda)
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

      Collection.Indexes.CreateOne(new CreateIndexModel<Produto>(
        Builders<Produto>.IndexKeys.Descending(_ => _.IsAtivo)
      ));

      _favoriteItemRepository = favoriteItemRepository;
    }

    public async Task CreateAsync(Produto produto)
      => await Collection.InsertOneAsync(produto);

    public async Task<bool> ExisteProdutoPorCodigoBarras(string codigoBarras, string? id)
    {
      var filtro = Builders<Produto>.Filter.Eq(p => p.CodigoBarras, codigoBarras);

      if (!string.IsNullOrEmpty(id))
      {
        filtro &= Builders<Produto>.Filter.Ne(p => p.Id, id);
      }

      var count = await Collection.CountDocumentsAsync(filtro);

      return count > 0;
    }

    public async Task<bool> ExisteProdutoPorNome(string nome, string? id)
    {
      var filtro = Builders<Produto>.Filter.Eq(p => p.Nome, nome);

      if (!string.IsNullOrEmpty(id))
      {
        filtro &= Builders<Produto>.Filter.Ne(p => p.Id, id);
      }

      var count = await Collection.CountDocumentsAsync(filtro);

      return count > 0;
    }

    public async Task<Produto?> GetAsync(string id)
      => await Collection.Find(p => p.Id == id).FirstOrDefaultAsync();

    public async Task<PagedResult<ProdutoDto>> GetProdutosAsync(ProdutoQuery produtoQuery)
    {
      var filtro = Builders<Produto>.Filter.Empty;

      if (!string.IsNullOrWhiteSpace(produtoQuery.nome))
      {
        filtro &= Builders<Produto>.Filter.Regex(p => p.Nome, new BsonRegularExpression(new Regex(produtoQuery.nome, RegexOptions.IgnoreCase)));
      }

      var start = (produtoQuery.page - 1) * produtoQuery.limit;

      var projections = Builders<Produto>.Projection
        .Expression(p => new ProdutoDto
        {
          Id = p.Id,
          Nome = p.Nome,
          Descricao = p.Descricao,
          ImageUrl = p.ImageUrl,
          Preco = p.Preco,
          UnidadeMedida = p.UnidadeMedida,
          EstoqueAlvo = p.EstoqueAlvo,
          Estoque = p.Estoque,
          Rating = p.Rating,
          RatingCount = p.RatingCount,
          IsAtivo = p.IsAtivo
        });

      var produtos = await Collection.Find(filtro)
        .SortByDescending(p => p.IsAtivo)
        .ThenBy(p => p.Nome)
        .Skip((produtoQuery.page - 1) * produtoQuery.limit)
        .Limit(produtoQuery.limit)
        .Project(projections)
        .ToListAsync();

      var count = await Collection.CountDocumentsAsync(filtro);

      return new PagedResult<ProdutoDto>(start, produtoQuery.limit, count, produtos);
    }

    public async Task UpdateAsync(Produto produto)
      => await Collection.ReplaceOneAsync(p => p.Id == produto.Id, produto);

    public async Task<PagedResult<CatalogoDto>> GetProdutosFavoritosAsync(string userId, CatalogoQuery query)
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
          { "Id", "$ProdutoId" },
          { "Nome", "$produto.Nome" },
          { "UnidadeMedida", "$produto.UnidadeMedida" },
          { "ImageUrl", "$produto.ImageUrl" },
          { "Estoque", "$produto.Estoque" },
          { "Preco", "$produto.Preco" },
          { "IsAtivo", "$produto.IsAtivo" },
        });

      var skipStage = new BsonDocument("$skip", start);
      var limitStage = new BsonDocument("$limit", query.limit);

      var pipeline = new[] { lookupStage, unwindStage, matchStage, projectStage, skipStage, limitStage };
      var aggregation = await _favoriteItemRepository.Collection.Aggregate<CatalogoDto>(pipeline).ToListAsync();

      var count = await _favoriteItemRepository.Collection.CountDocumentsAsync(Builders<FavoritoItem>.Filter.Eq(_ => _.UserId, userId));

      return new PagedResult<CatalogoDto>(start, query.limit, count, aggregation);
    }

    public async Task<PagedResult<CatalogoDto>> GetProdutosMaisVendidosAsync(CatalogoQuery catalogoQuery)
    {
      var filtro = Builders<Produto>.Filter.Ne(p => p.QuantidadeVendida, 0);
      filtro &= Builders<Produto>.Filter.Eq(p => p.IsAtivo, true);

      var start = (catalogoQuery.page - 1) * catalogoQuery.limit;

      var projections = Builders<Produto>.Projection
        .Expression(p => new CatalogoDto
        {
          Id = p.Id,
          Nome = p.Nome,
          ImageUrl = p.ImageUrl,
          Preco = p.Preco,
          UnidadeMedida = p.UnidadeMedida,
          Estoque = p.Estoque,
          IsAtivo = p.IsAtivo
        });

      var catalogo = await Collection.Find(filtro)
        .SortByDescending(p => p.QuantidadeVendida)
        .Skip((catalogoQuery.page - 1) * catalogoQuery.limit)
        .Limit(catalogoQuery.limit)
        .Project(projections)
        .ToListAsync();

      var count = await Collection.CountDocumentsAsync(filtro);

      return new PagedResult<CatalogoDto>(start, catalogoQuery.limit, count, catalogo);
    }

    public async Task<PagedResult<CatalogoDto>> GetProdutosNovosAsync(CatalogoQuery catalogoQuery)
    {
      var filtro = Builders<Produto>.Filter.Eq(p => p.IsAtivo, true);

      var start = (catalogoQuery.page - 1) * catalogoQuery.limit;

      var projections = Builders<Produto>.Projection
        .Expression(p => new CatalogoDto
        {
          Id = p.Id,
          Nome = p.Nome,
          ImageUrl = p.ImageUrl,
          Preco = p.Preco,
          UnidadeMedida = p.UnidadeMedida,
          Estoque = p.Estoque,
          IsAtivo = p.IsAtivo
        });

      var catalogo = await Collection.Find(filtro)
        .SortByDescending(p => p.DataCriacao)
        .Skip((catalogoQuery.page - 1) * catalogoQuery.limit)
        .Limit(catalogoQuery.limit)
        .Project(projections)
        .ToListAsync();

      var count = await Collection.CountDocumentsAsync(filtro);

      return new PagedResult<CatalogoDto>(start, catalogoQuery.limit, count, catalogo);
    }

    public async Task<PagedResult<CatalogoDto>> GetProdutosUltimosVendidosAsync(CatalogoQuery catalogoQuery)
    {
      var filtro = Builders<Produto>.Filter.Ne(p => p.DataUltimaVenda, null);
      filtro &= Builders<Produto>.Filter.Eq(p => p.IsAtivo, true);

      var start = (catalogoQuery.page - 1) * catalogoQuery.limit;

      var projections = Builders<Produto>.Projection
        .Expression(p => new CatalogoDto
        {
          Id = p.Id,
          Nome = p.Nome,
          ImageUrl = p.ImageUrl,
          Preco = p.Preco,
          UnidadeMedida = p.UnidadeMedida,
          Estoque = p.Estoque,
          IsAtivo = p.IsAtivo
        });

      var catalogo = await Collection.Find(filtro)
        .SortByDescending(p => p.DataUltimaVenda)
        .Skip((catalogoQuery.page - 1) * catalogoQuery.limit)
        .Limit(catalogoQuery.limit)
        .Project(projections)
        .ToListAsync();

      var count = await Collection.CountDocumentsAsync(filtro);

      return new PagedResult<CatalogoDto>(start, catalogoQuery.limit, count, catalogo);
    }
  }
}