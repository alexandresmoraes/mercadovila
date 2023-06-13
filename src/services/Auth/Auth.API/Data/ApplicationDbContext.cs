using Auth.API.Data.Entities;
using Common.WebAPI.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Auth.API.Data
{
  public class ApplicationDbContext : IdentityDbContext<ApplicationUser, IdentityRole, string>
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

      modelBuilder.Entity<ApplicationUser>(b =>
      {
        b.HasKey(e => e.Id);
        b.Property(e => e.Id).HasMaxLength(36).ValueGeneratedOnAdd();
        b.Property(e => e.UserName).HasMaxLength(128);
        b.Property(e => e.NormalizedUserName).HasMaxLength(128);
        b.Property(e => e.Email).HasMaxLength(128);
        b.Property(e => e.NormalizedEmail).HasMaxLength(128);
        b.Property(e => e.PasswordHash).HasMaxLength(256);
        b.Property(e => e.SecurityStamp).HasMaxLength(36);
        b.Property(e => e.ConcurrencyStamp).HasMaxLength(36);
        b.Property(e => e.PhoneNumber).HasMaxLength(17);
        b.Property(e => e.FotoUrl).HasMaxLength(128);
        b.Property(e => e.IsAtivo);

        b.HasIndex(u => u.NormalizedUserName).HasDatabaseName("users_username_index").IsUnique();
        b.HasIndex(u => u.NormalizedEmail).HasDatabaseName("users_email_index").IsUnique();

        b.HasMany<IdentityUserClaim<string>>().WithOne().HasForeignKey(uc => uc.UserId).IsRequired();
        b.HasMany<IdentityUserLogin<string>>().WithOne().HasForeignKey(ul => ul.UserId).IsRequired();
        b.HasMany<IdentityUserToken<string>>().WithOne().HasForeignKey(ut => ut.UserId).IsRequired();
        b.HasMany<IdentityUserRole<string>>().WithOne().HasForeignKey(ur => ur.UserId).IsRequired();

        b.ToTable("users");
      });

      modelBuilder.Entity<IdentityRole>(b =>
      {
        b.HasKey(e => e.Id);
        b.Property(e => e.Id).HasMaxLength(36);
        b.Property(e => e.Name).HasMaxLength(128);
        b.Property(e => e.NormalizedName).HasMaxLength(128);
        b.Property(e => e.ConcurrencyStamp).HasMaxLength(36);

        b.HasIndex(r => r.NormalizedName).HasDatabaseName("roles_rolename_index").IsUnique();

        b.HasMany<IdentityUserRole<string>>().WithOne().HasForeignKey(ur => ur.RoleId).IsRequired();
        b.HasMany<IdentityRoleClaim<string>>().WithOne().HasForeignKey(rc => rc.RoleId).IsRequired();

        b.ToTable("roles");
      });

      modelBuilder.Entity<IdentityUserRole<string>>(b =>
      {
        b.Property(e => e.UserId).HasMaxLength(36);
        b.Property(e => e.RoleId).HasMaxLength(36);

        b.ToTable("user_roles");
      });

      modelBuilder.Entity<IdentityUserClaim<string>>(b =>
      {
        b.Property(e => e.Id).HasMaxLength(36);
        b.Property(e => e.UserId).HasMaxLength(36);
        b.Property(e => e.ClaimType).HasMaxLength(128);
        b.Property(e => e.ClaimValue).HasMaxLength(128);

        b.ToTable("user_claims");
      });

      modelBuilder.Entity<IdentityUserLogin<string>>(b =>
      {
        b.Property(e => e.LoginProvider).HasMaxLength(128);
        b.Property(e => e.ProviderKey).HasMaxLength(128);
        b.Property(e => e.ProviderDisplayName).HasMaxLength(128);
        b.Property(e => e.UserId).HasMaxLength(36);

        b.ToTable("user_logins");
      });

      modelBuilder.Entity<IdentityRoleClaim<string>>(b =>
      {
        b.HasKey(e => e.Id);
        b.Property(e => e.Id).HasMaxLength(36);
        b.Property(e => e.RoleId).HasMaxLength(36);
        b.Property(e => e.ClaimType).HasMaxLength(128);
        b.Property(e => e.ClaimValue).HasMaxLength(128);

        b.ToTable("role_claims");
      });

      modelBuilder.Entity<IdentityUserToken<string>>(b =>
      {
        b.Property(e => e.UserId).HasMaxLength(36);
        b.Property(e => e.LoginProvider).HasMaxLength(128);
        b.Property(e => e.Name).HasMaxLength(36);
        b.Property(e => e.Value).HasMaxLength(256);

        b.ToTable("user_tokens");
      });

      var roleAdmin = new IdentityRole("admin") { NormalizedName = "ADMIN" };
      modelBuilder.Entity<IdentityRole>().HasData(roleAdmin);

      var userAdmin = new ApplicationUser
      {
        Id = Guid.NewGuid().ToString(),
        SecurityStamp = Guid.NewGuid().ToString(),
        Nome = "Admin",
        UserName = "admin",
        Email = "admin@admin.com",
        NormalizedUserName = "ADMIN",
        NormalizedEmail = "ADMIN@ADMIN.COM",
        PhoneNumber = "+55 46 99909-7070",
        IsAtivo = true
      };
      var hasher = new PasswordHasher<ApplicationUser>();
      userAdmin.PasswordHash = hasher.HashPassword(userAdmin, "admin");
      modelBuilder.Entity<ApplicationUser>().HasData(userAdmin);

      modelBuilder.Entity<IdentityUserRole<string>>().HasData(
            new IdentityUserRole<string> { RoleId = roleAdmin.Id, UserId = userAdmin.Id }
        );
    }
  }
}