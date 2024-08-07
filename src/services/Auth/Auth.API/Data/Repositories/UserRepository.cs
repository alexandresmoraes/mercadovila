﻿using Auth.API.Data.Dto;
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
        query = query.Where(x => x.NormalizedUserName.Contains(userQuery.username.ToUpper())
                      || x.NormalizedEmail.Contains(userQuery.username.ToUpper()));
      }

      var total = await query.CountAsync();

      var start = (userQuery.page - 1) * userQuery.limit;

      var users = query
        .OrderByDescending(u => u.IsAtivo)
        .ThenBy(u => u.NormalizedUserName)
        .Skip(start).Take(userQuery.limit)
        .Select(account => new AccountDto()
        {
          Id = account.Id,
          Username = account.UserName,
          PhoneNumber = account.PhoneNumber,
          FotoUrl = account.FotoUrl,
          Email = account.Email,
          IsAtivo = account.IsAtivo
        })
        .ToList();

      return new PagedResult<AccountDto>(start, userQuery.limit, total, users);
    }
  }
}