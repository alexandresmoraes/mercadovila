using Auth.API.Data.Dto;
using Auth.API.Data.Queries;
using Common.WebAPI.Results;

namespace Auth.API.Data.Repositories
{
  public interface IUserRepository
  {
    public Task<PagedResult<AccountDto>> GetUsersPaginationAsync(UserQuery userQuery);
  }
}