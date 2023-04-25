using Common.WebAPI.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;

namespace Auth.API.Data
{
  public class ApplicationDbContext : IdentityDbContext
  {
    protected readonly IConfiguration _configuration;

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options, IConfiguration configuration) : base(options)
    {
      _configuration = configuration;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
      options.UseNpgsql(_configuration.GetConnectionString("Default"), opt =>
      {
        opt.SetPostgresVersion(new Version("9.6"));
      })
      .ReplaceService<ISqlGenerationHelper, NpgsqlSqlGenerationLowercasingHelper>();

      AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      base.OnModelCreating(modelBuilder);

      modelBuilder.Entity<IdentityUser>(b =>
      {
        b.ToTable("users");
        b.Property(u => u.UserName).HasMaxLength(128);
        b.Property(u => u.NormalizedUserName).HasMaxLength(128);
        b.Property(u => u.Email).HasMaxLength(128);
        b.Property(u => u.NormalizedEmail).HasMaxLength(128);

        b.Property(u => u.ConcurrencyStamp).HasMaxLength(100);
      });

      modelBuilder.Entity<IdentityRole>(b =>
      {
        b.ToTable("roles");
      });

      modelBuilder.Entity<IdentityUserRole<string>>(b =>
      {
        b.ToTable("user_roles");
      });

      modelBuilder.Entity<IdentityUserClaim<string>>(b =>
      {
        b.ToTable("user_claims");
      });

      modelBuilder.Entity<IdentityUserLogin<string>>(b =>
      {
        b.ToTable("user_logins");
      });

      modelBuilder.Entity<IdentityRoleClaim<string>>(b =>
      {
        b.ToTable("role_claims");
      });

      modelBuilder.Entity<IdentityUserToken<string>>(b =>
      {
        b.ToTable("user_tokens");
      });
    }
  }
}