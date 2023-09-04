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

      if (!string.IsNullOrWhiteSpace(userQuery.Username))
      {
        query = query.Where(x => x.NormalizedUserName.Contains(userQuery.Username.ToUpper())
                      || x.NormalizedEmail.Contains(userQuery.Username.ToUpper()));
      }

      var total = await query.CountAsync();

      var start = (userQuery.Page - 1) * userQuery.Limit;

      var users = query
        .OrderByDescending(u => u.IsAtivo)
        .ThenBy(u => u.NormalizedUserName)
        .Skip(start).Take(userQuery.Limit)
        .Select(account => new AccountDto()
        {
          Id = account.Id,
          Username = account.UserName,
          PhoneNumber = account.PhoneNumber,
          Email = account.Email,
          IsAtivo = account.IsAtivo
        })
        .ToList();

      return new PagedResult<AccountDto>(start, userQuery.Limit, total, users);
    }
  }
}