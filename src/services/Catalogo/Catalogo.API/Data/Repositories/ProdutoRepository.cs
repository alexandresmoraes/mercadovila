using Catalogo.API.Data.Dto;
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
    public ProdutoRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
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
          Preco = p.Preco,
          UnidadeMedida = p.UnidadeMedida,
          EstoqueAlvo = p.EstoqueAlvo,
          Estoque = p.Estoque,
          Rating = p.Rating,
          RatingCount = p.RatingCount,
          IsAtivo = p.IsAtivo
        });

      var produtos = await Collection.Find(filtro)
        .SortBy(p => p.Nome)
        .Skip((produtoQuery.page - 1) * produtoQuery.limit)
        .Limit(produtoQuery.limit)
        .Project(projections)
        .ToListAsync();

      var count = await Collection.CountDocumentsAsync(filtro);

      return new PagedResult<ProdutoDto>(start, produtoQuery.limit, count, produtos);
    }

    public async Task UpdateAsync(Produto produto)
      => await Collection.ReplaceOneAsync(p => p.Id == produto.Id, produto);
  }
}