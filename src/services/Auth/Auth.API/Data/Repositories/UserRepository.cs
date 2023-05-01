using Auth.API.Data.Dto;
using Auth.API.Data.Queries;
using Common.WebAPI.Results;
using Microsoft.EntityFrameworkCore;

namespace Auth.API.Data.Repositories
{
  public class UserRepository : IUserRepository
  {
    private readonly ApplicationDbContext _context;

    public UserRepository(ApplicationDbContext context)
    {
      _context = context ?? throw new ArgumentNullException(nameof(context));
    }

    public async Task<PagedResult<UserDto>> GetUsersPagination(UserQuery userQuery)
    {
      var query = _context.Users.AsQueryable().AsNoTrackingWithIdentityResolution();

      var total = await query.CountAsync();

      var users = query
        .Skip(userQuery.start).Take(userQuery.limit)
        .Select(x => new UserDto()
        {
          Id = x.Id,
          Username = x.UserName,
          PhoneNumber = x.PhoneNumber,
          Email = x.Email
        })
        .ToList();

      return new PagedResult<UserDto>(userQuery.start, userQuery.limit, total, users);
    }
  }
}