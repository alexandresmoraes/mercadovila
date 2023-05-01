using Auth.API.Data.Dto;
using Auth.API.Data.Queries;
using Common.WebAPI.Results;

namespace Auth.API.Data.Repositories
{
  public interface IUserRepository
  {
    public Task<PagedResult<UserDto>> GetUsersPagination(UserQuery userQuery);
  }
}