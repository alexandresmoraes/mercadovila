using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Queries;
using Common.WebAPI.MongoDb;
using Common.WebAPI.Results;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Catalogo.API.Data.Repositories
{
  public class NotificacoesRepository : MongoService<Notificacao>, INotificacoesRepository
  {
    public NotificacoesRepository(IMongoClient mongoClient, IOptions<MongoDbSettings> opt)
     : base(mongoClient, opt, "notificacoes")
    {
      Collection.Indexes.CreateOne(new CreateIndexModel<Notificacao>(
        Builders<Notificacao>.IndexKeys.Descending(_ => _.DataCriacao)        
      ));      
    }

    public async Task CreateAsync(Notificacao notificacao)
      => await Collection.InsertOneAsync(notificacao);

    public async Task<bool> DeleteAsync(string id) {      
      var filter = Builders<Notificacao>.Filter.Eq(x => x.Id, id);
      
      var result = await Collection.DeleteOneAsync(filter);

      return result.DeletedCount > 0;
    }

    public async Task<Notificacao?> GetAsync(string id)
      => await Collection.Find(p => p.Id == id).FirstOrDefaultAsync();

    public async Task<PagedResult<NotificacaoDto>> GetNotificacoesAsync(NotificacaoQuery notificacaoQuery)
    {
      var filtro = Builders<Notificacao>.Filter.Empty;      

      var start = (notificacaoQuery.page - 1) * notificacaoQuery.limit;

      var projections = Builders<Notificacao>.Projection
        .Expression(n => new NotificacaoDto
        {
          Id = n.Id,
          Titulo = n.Titulo,
          Mensagem = n.Mensagem,
          ImageUrl = n.ImageUrl,
          DataCriacao = n.DataCriacao
        });

      var notificacoes = await Collection.Find(filtro)
        .SortByDescending(n => n.DataCriacao)        
        .Skip((notificacaoQuery.page - 1) * notificacaoQuery.limit)
        .Limit(notificacaoQuery.limit)
        .Project(projections)
        .ToListAsync();

      var count = await Collection.CountDocumentsAsync(filtro);

      return new PagedResult<NotificacaoDto>(start, notificacaoQuery.limit, count, notificacoes);
    }

    public async Task UpdateAsync(Notificacao notificacao)
      => await Collection.ReplaceOneAsync(p => p.Id == notificacao.Id, notificacao);
  }
}