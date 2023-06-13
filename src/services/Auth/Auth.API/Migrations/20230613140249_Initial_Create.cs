using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Auth.API.Migrations
{
    public partial class Initial_Create : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "roles",
                columns: table => new
                {
                    Id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    Name = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    NormalizedName = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "users",
                columns: table => new
                {
                    Id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    Nome = table.Column<string>(type: "text", nullable: false),
                    IsAtivo = table.Column<bool>(type: "boolean", nullable: false),
                    FotoUrl = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    UserName = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    Email = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    PasswordHash = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    SecurityStamp = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    PhoneNumber = table.Column<string>(type: "character varying(17)", maxLength: 17, nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_users", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "role_claims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", maxLength: 36, nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    RoleId = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    ClaimType = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    ClaimValue = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_role_claims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_role_claims_roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_claims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", maxLength: 36, nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    ClaimType = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    ClaimValue = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_claims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_user_claims_users_UserId",
                        column: x => x.UserId,
                        principalTable: "users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_logins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false),
                    ProviderKey = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    UserId = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_logins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_user_logins_users_UserId",
                        column: x => x.UserId,
                        principalTable: "users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_roles",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    RoleId = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_roles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_user_roles_roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_user_roles_users_UserId",
                        column: x => x.UserId,
                        principalTable: "users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_tokens",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    LoginProvider = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false),
                    Name = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    Value = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_tokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_user_tokens_users_UserId",
                        column: x => x.UserId,
                        principalTable: "users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "roles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "7cfb56a1-afca-4a5a-9deb-800c5c9cf28f", "f497e5f8-72be-4dcc-a4e9-1572ed103978", "admin", "ADMIN" });

            migrationBuilder.InsertData(
                table: "users",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Email", "EmailConfirmed", "FotoUrl", "IsAtivo", "LockoutEnabled", "LockoutEnd", "Nome", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "7204cc92-9a71-414d-b170-d42e09374c9b", 0, "a521108b-55cb-45a6-bc9b-d1fbaef94b9c", "admin@admin.com", false, null, true, false, null, "Admin", "ADMIN@ADMIN.COM", "ADMIN", "AQAAAAEAACcQAAAAEEPQ3OF4lkqktpuzs4SvVEDoBqjmxQID+MDSD/aF0TP8YSKBH/YtZugxtYUkgbGuSg==", "+55 46 99909-7070", false, "d20e7c8f-ed49-45c5-a534-7617df25c9f2", false, "admin" });

            migrationBuilder.InsertData(
                table: "user_roles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[] { "7cfb56a1-afca-4a5a-9deb-800c5c9cf28f", "7204cc92-9a71-414d-b170-d42e09374c9b" });

            migrationBuilder.CreateIndex(
                name: "IX_role_claims_RoleId",
                table: "role_claims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "roles_rolename_index",
                table: "roles",
                column: "NormalizedName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_user_claims_UserId",
                table: "user_claims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_user_logins_UserId",
                table: "user_logins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_user_roles_RoleId",
                table: "user_roles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "users_email_index",
                table: "users",
                column: "NormalizedEmail",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "users_username_index",
                table: "users",
                column: "NormalizedUserName",
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "role_claims");

            migrationBuilder.DropTable(
                name: "user_claims");

            migrationBuilder.DropTable(
                name: "user_logins");

            migrationBuilder.DropTable(
                name: "user_roles");

            migrationBuilder.DropTable(
                name: "user_tokens");

            migrationBuilder.DropTable(
                name: "roles");

            migrationBuilder.DropTable(
                name: "users");
        }
    }
}
