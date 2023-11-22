using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Vendas.Infra.Migrations
{
    public partial class Initial_Create : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "compradores",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    user_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    nome = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                    foto_url = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_compradores", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "pagamentos",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    comprador_id = table.Column<long>(type: "bigint", nullable: false),
                    tipo = table.Column<int>(type: "integer", nullable: false),
                    valor = table.Column<decimal>(type: "numeric", nullable: false),
                    datahora = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_pagamentos", x => x.id);
                    table.ForeignKey(
                        name: "FK_pagamentos_compradores_comprador_id",
                        column: x => x.comprador_id,
                        principalTable: "compradores",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "vendas",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    comprador_id = table.Column<long>(type: "bigint", nullable: false),
                    status = table.Column<int>(type: "integer", nullable: false),
                    datahora = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    total = table.Column<decimal>(type: "numeric", nullable: false),
                    pagamento_id = table.Column<long>(type: "bigint", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_vendas", x => x.id);
                    table.ForeignKey(
                        name: "FK_vendas_compradores_comprador_id",
                        column: x => x.comprador_id,
                        principalTable: "compradores",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_vendas_pagamentos_pagamento_id",
                        column: x => x.pagamento_id,
                        principalTable: "pagamentos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "venda_itens",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    produto_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    nome = table.Column<string>(type: "text", nullable: false),
                    image_url = table.Column<string>(type: "text", nullable: false),
                    descricao = table.Column<string>(type: "text", nullable: false),
                    preco = table.Column<decimal>(type: "numeric", nullable: false),
                    quantidade = table.Column<int>(type: "integer", nullable: false),
                    unidade_medida = table.Column<string>(type: "text", nullable: false),
                    venda_id = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_venda_itens", x => x.id);
                    table.ForeignKey(
                        name: "FK_venda_itens_vendas_venda_id",
                        column: x => x.venda_id,
                        principalTable: "vendas",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "comprador_userid_index",
                table: "compradores",
                column: "user_id",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_pagamentos_comprador_id",
                table: "pagamentos",
                column: "comprador_id");

            migrationBuilder.CreateIndex(
                name: "IX_venda_itens_venda_id",
                table: "venda_itens",
                column: "venda_id");

            migrationBuilder.CreateIndex(
                name: "IX_vendas_comprador_id",
                table: "vendas",
                column: "comprador_id");

            migrationBuilder.CreateIndex(
                name: "IX_vendas_pagamento_id",
                table: "vendas",
                column: "pagamento_id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "venda_itens");

            migrationBuilder.DropTable(
                name: "vendas");

            migrationBuilder.DropTable(
                name: "pagamentos");

            migrationBuilder.DropTable(
                name: "compradores");
        }
    }
}
