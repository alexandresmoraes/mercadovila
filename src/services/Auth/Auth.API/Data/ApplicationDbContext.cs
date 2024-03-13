using Auth.API.Data.Entities;
using Common.WebAPI.PostgreSql;
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
      options.UseNpgsqlExtension(_configuration);
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      base.OnModelCreating(modelBuilder);

      modelBuilder.Entity<ApplicationUser>(b =>
      {
        b.HasKey(e => e.Id);
        b.Property(e => e.Id).HasColumnName("id").HasMaxLength(36).ValueGeneratedOnAdd();
        b.Property(e => e.Nome).HasColumnName("nome").HasMaxLength(256);
        b.Property(e => e.UserName).HasColumnName("username").HasMaxLength(128);
        b.Property(e => e.NormalizedUserName).HasColumnName("normalized_username").HasMaxLength(128);
        b.Property(e => e.Email).HasColumnName("email").HasMaxLength(128);
        b.Property(e => e.NormalizedEmail).HasColumnName("normalized_email").HasMaxLength(128);
        b.Property(e => e.EmailConfirmed).HasColumnName("email_confirmed");
        b.Property(e => e.PasswordHash).HasColumnName("password_hash").HasMaxLength(256);
        b.Property(e => e.SecurityStamp).HasColumnName("security_stamp").HasMaxLength(36);
        b.Property(e => e.ConcurrencyStamp).HasColumnName("concurrency_stamp").HasMaxLength(36);
        b.Property(e => e.PhoneNumber).HasColumnName("phone_number").HasMaxLength(17);
        b.Property(e => e.PhoneNumberConfirmed).HasColumnName("phone_number_confirmed");
        b.Property(e => e.TwoFactorEnabled).HasColumnName("two_factor_enabled");
        b.Property(e => e.LockoutEnd).HasColumnName("lockout_end");
        b.Property(e => e.LockoutEnabled).HasColumnName("lockout_end_enabled");
        b.Property(e => e.FotoUrl).HasColumnName("foto_url").HasMaxLength(128);
        b.Property(e => e.IsAtivo).HasColumnName("isativo");
        b.Property(e => e.AccessFailedCount).HasColumnName("access_failed_count");

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
        b.Property(e => e.Id).HasColumnName("id").HasMaxLength(36);
        b.Property(e => e.Name).HasColumnName("name").HasMaxLength(128);
        b.Property(e => e.NormalizedName).HasColumnName("normalized_name").HasMaxLength(128);
        b.Property(e => e.ConcurrencyStamp).HasColumnName("concurrency_stamp").HasMaxLength(36);

        b.HasIndex(r => r.NormalizedName).HasDatabaseName("roles_rolename_index").IsUnique();

        b.HasMany<IdentityUserRole<string>>().WithOne().HasForeignKey(ur => ur.RoleId).IsRequired();
        b.HasMany<IdentityRoleClaim<string>>().WithOne().HasForeignKey(rc => rc.RoleId).IsRequired();

        b.ToTable("roles");
      });

      modelBuilder.Entity<IdentityUserRole<string>>(b =>
      {
        b.Property(e => e.UserId).HasColumnName("user_id").HasMaxLength(36);
        b.Property(e => e.RoleId).HasColumnName("role_id").HasMaxLength(36);

        b.ToTable("user_roles");
      });

      modelBuilder.Entity<IdentityUserClaim<string>>(b =>
      {
        b.Property(e => e.Id).HasColumnName("id").HasMaxLength(36);
        b.Property(e => e.UserId).HasColumnName("user_id").HasMaxLength(36);
        b.Property(e => e.ClaimType).HasColumnName("claim_type").HasMaxLength(128);
        b.Property(e => e.ClaimValue).HasColumnName("claim_value").HasMaxLength(128);

        b.ToTable("user_claims");
      });

      modelBuilder.Entity<IdentityUserLogin<string>>(b =>
      {
        b.Property(e => e.LoginProvider).HasColumnName("login_provider").HasMaxLength(128);
        b.Property(e => e.ProviderKey).HasColumnName("provider_key").HasMaxLength(128);
        b.Property(e => e.ProviderDisplayName).HasColumnName("provider_display_name").HasMaxLength(128);
        b.Property(e => e.UserId).HasColumnName("user_id").HasMaxLength(36);

        b.ToTable("user_logins");
      });

      modelBuilder.Entity<IdentityRoleClaim<string>>(b =>
      {
        b.HasKey(e => e.Id);
        b.Property(e => e.Id).HasColumnName("id").HasMaxLength(36);
        b.Property(e => e.RoleId).HasColumnName("role_id").HasMaxLength(36);
        b.Property(e => e.ClaimType).HasColumnName("claim_type").HasMaxLength(128);
        b.Property(e => e.ClaimValue).HasColumnName("claim_value").HasMaxLength(128);

        b.ToTable("role_claims");
      });

      modelBuilder.Entity<IdentityUserToken<string>>(b =>
      {
        b.Property(e => e.UserId).HasColumnName("user_id").HasMaxLength(36);
        b.Property(e => e.LoginProvider).HasColumnName("login_provider").HasMaxLength(128);
        b.Property(e => e.Name).HasColumnName("name").HasMaxLength(36);
        b.Property(e => e.Value).HasColumnName("value").HasMaxLength(256);

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
        PhoneNumber = "(46) 99999-7070",
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