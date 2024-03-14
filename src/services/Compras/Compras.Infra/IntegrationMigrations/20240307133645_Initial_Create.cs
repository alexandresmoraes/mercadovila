using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.Infra.IntegrationMigrations
{
    public partial class Initial_Create : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "integration_event",
                columns: table => new
                {
                    event_id = table.Column<string>(type: "text", nullable: false),
                    event_type_name = table.Column<string>(type: "text", nullable: false),
                    state = table.Column<int>(type: "integer", nullable: false),
                    times_sent = table.Column<int>(type: "integer", nullable: false),
                    creation_time = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    content = table.Column<string>(type: "text", nullable: false),
                    transaction_id = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_integration_event", x => x.event_id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "integration_event");
        }
    }
}
