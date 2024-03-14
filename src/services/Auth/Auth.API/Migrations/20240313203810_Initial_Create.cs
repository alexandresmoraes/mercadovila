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
                    id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    name = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    normalized_name = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    concurrency_stamp = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_roles", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "users",
                columns: table => new
                {
                    id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    nome = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                    isativo = table.Column<bool>(type: "boolean", nullable: false),
                    foto_url = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    username = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    normalized_username = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    email = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    normalized_email = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    email_confirmed = table.Column<bool>(type: "boolean", nullable: false),
                    password_hash = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    security_stamp = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    concurrency_stamp = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    phone_number = table.Column<string>(type: "character varying(17)", maxLength: 17, nullable: true),
                    phone_number_confirmed = table.Column<bool>(type: "boolean", nullable: false),
                    two_factor_enabled = table.Column<bool>(type: "boolean", nullable: false),
                    lockout_end = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    lockout_end_enabled = table.Column<bool>(type: "boolean", nullable: false),
                    access_failed_count = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_users", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "role_claims",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", maxLength: 36, nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    role_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    claim_type = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    claim_value = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_role_claims", x => x.id);
                    table.ForeignKey(
                        name: "FK_role_claims_roles_role_id",
                        column: x => x.role_id,
                        principalTable: "roles",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_claims",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", maxLength: 36, nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    user_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    claim_type = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    claim_value = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_claims", x => x.id);
                    table.ForeignKey(
                        name: "FK_user_claims_users_user_id",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_logins",
                columns: table => new
                {
                    login_provider = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false),
                    provider_key = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false),
                    provider_display_name = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: true),
                    user_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_logins", x => new { x.login_provider, x.provider_key });
                    table.ForeignKey(
                        name: "FK_user_logins_users_user_id",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_roles",
                columns: table => new
                {
                    user_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    role_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_roles", x => new { x.user_id, x.role_id });
                    table.ForeignKey(
                        name: "FK_user_roles_roles_role_id",
                        column: x => x.role_id,
                        principalTable: "roles",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_user_roles_users_user_id",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_tokens",
                columns: table => new
                {
                    user_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    login_provider = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false),
                    name = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    value = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_tokens", x => new { x.user_id, x.login_provider, x.name });
                    table.ForeignKey(
                        name: "FK_user_tokens_users_user_id",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "roles",
                columns: new[] { "id", "concurrency_stamp", "name", "normalized_name" },
                values: new object[] { "15ee84e8-c577-4889-9725-e14fb8ceebad", "70d87a9e-23a3-43b3-b4dc-571dc705af32", "admin", "ADMIN" });

            migrationBuilder.InsertData(
                table: "users",
                columns: new[] { "id", "access_failed_count", "concurrency_stamp", "email", "email_confirmed", "foto_url", "isativo", "lockout_end_enabled", "lockout_end", "nome", "normalized_email", "normalized_username", "password_hash", "phone_number", "phone_number_confirmed", "security_stamp", "two_factor_enabled", "username" },
                values: new object[] { "35eb87de-4d35-42fe-a49f-8a7f74d4780a", 0, "d72fdba6-8477-4518-b055-a773395ac72a", "admin@admin.com", false, null, true, false, null, "Admin", "ADMIN@ADMIN.COM", "ADMIN", "AQAAAAEAACcQAAAAEProPkJ2108Ak0rOaiHniImwXthJJblcv9IGp5s1t5xGgJQw240vzDHKJ/ndcxjCvg==", "(46) 99999-7070", false, "d99e5200-7c69-456b-8dde-a8c8c18d2ced", false, "admin" });

            migrationBuilder.InsertData(
                table: "user_roles",
                columns: new[] { "role_id", "user_id" },
                values: new object[] { "15ee84e8-c577-4889-9725-e14fb8ceebad", "35eb87de-4d35-42fe-a49f-8a7f74d4780a" });

            migrationBuilder.CreateIndex(
                name: "IX_role_claims_role_id",
                table: "role_claims",
                column: "role_id");

            migrationBuilder.CreateIndex(
                name: "roles_rolename_index",
                table: "roles",
                column: "normalized_name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_user_claims_user_id",
                table: "user_claims",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_user_logins_user_id",
                table: "user_logins",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_user_roles_role_id",
                table: "user_roles",
                column: "role_id");

            migrationBuilder.CreateIndex(
                name: "users_email_index",
                table: "users",
                column: "normalized_email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "users_username_index",
                table: "users",
                column: "normalized_username",
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
