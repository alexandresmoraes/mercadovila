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

    public async Task<PagedResult<AccountDto>> GetUsersPaginationAsync(UserQuery userQuery)
    {
      var query = _context.Users
        .AsQueryable().AsNoTrackingWithIdentityResolution();

      if (!string.IsNullOrWhiteSpace(userQuery.username))
      {
        query.Where(u => u.NormalizedUserName == userQuery.username.ToUpper());
      }

      var total = await query.CountAsync();

      var start = (userQuery.page - 1) * userQuery.limit;

      var users = query
        .Skip(start).Take(userQuery.limit)
        .Select(x => new AccountDto()
        {
          Id = x.Id,
          Username = x.UserName,
          PhoneNumber = x.PhoneNumber,
          Email = x.Email
        })
        .ToList();

      return new PagedResult<AccountDto>(start, userQuery.limit, total, users);
    }
  }
}