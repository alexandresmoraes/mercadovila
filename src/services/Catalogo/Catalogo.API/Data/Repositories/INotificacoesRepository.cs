using System;
using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Entities;
using Catalogo.API.Data.Queries;
using Common.WebAPI.Results;

namespace Catalogo.API.Data.Repositories
{
  public interface INotificacoesRepository
  {
    Task CreateAsync(Notificacao notificacao);
    Task UpdateAsync(Notificacao notificacao);
    Task<bool> DeleteAsync(string id);
    Task<Notificacao?> GetAsync(string id);
    Task<PagedResult<NotificacaoDto>> GetNotificacoesAsync(NotificacaoQuery notificacaoQuery);
  }
}

