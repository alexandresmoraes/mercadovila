using Common.WebAPI.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

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
      options.UseNpgsql(_configuration);
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      base.OnModelCreating(modelBuilder);

      modelBuilder.Entity<IdentityUser>(b =>
      {
        b.HasKey(e => e.Id);
        b.Property(e => e.Id).HasMaxLength(36);
        b.Property(e => e.UserName).HasMaxLength(128);
        b.Property(e => e.NormalizedUserName).HasMaxLength(128);
        b.Property(e => e.Email).HasMaxLength(128);
        b.Property(e => e.NormalizedEmail).HasMaxLength(128);
        b.Property(e => e.ConcurrencyStamp).HasMaxLength(100);

        b.ToTable("users");
      });

      modelBuilder.Entity<IdentityRole>(b =>
      {
        b.HasData(
          new IdentityRole("admin") { NormalizedName = "ADMIN" },
          new IdentityRole("user") { NormalizedName = "USER" });

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