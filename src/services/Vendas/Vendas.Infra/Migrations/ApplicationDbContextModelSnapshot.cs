﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
using Vendas.Infra.Data;

#nullable disable

namespace Vendas.Infra.Migrations
{
    [DbContext(typeof(ApplicationDbContext))]
    partial class ApplicationDbContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.16")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("Vendas.Domain.Aggregates.Comprador", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<long>("Id"));

                    b.Property<string>("Nome")
                        .IsRequired()
                        .HasMaxLength(256)
                        .HasColumnType("character varying(256)");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasMaxLength(36)
                        .HasColumnType("character varying(36)");

                    b.HasKey("Id");

                    b.HasIndex("UserId")
                        .IsUnique()
                        .HasDatabaseName("comprador_userid_index");

                    b.ToTable("compradores", (string)null);
                });

            modelBuilder.Entity("Vendas.Domain.Aggregates.Pagamento.Pagamento", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<long>("Id"));

                    b.Property<long>("CompradorId")
                        .HasColumnType("bigint");

                    b.Property<DateTime>("DataHora")
                        .HasColumnType("timestamp without time zone");

                    b.Property<int>("Tipo")
                        .HasColumnType("integer");

                    b.Property<decimal>("Valor")
                        .HasColumnType("numeric");

                    b.HasKey("Id");

                    b.HasIndex("CompradorId");

                    b.ToTable("pagamentos", (string)null);
                });

            modelBuilder.Entity("Vendas.Domain.Aggregates.Venda", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<long>("Id"));

                    b.Property<long>("CompradorId")
                        .HasColumnType("bigint");

                    b.Property<DateTime>("DataHora")
                        .HasColumnType("timestamp without time zone");

                    b.Property<long?>("PagamentoId")
                        .HasColumnType("bigint");

                    b.Property<int>("Status")
                        .HasColumnType("integer");

                    b.Property<decimal>("Total")
                        .HasColumnType("numeric");

                    b.HasKey("Id");

                    b.HasIndex("CompradorId");

                    b.HasIndex("PagamentoId");

                    b.ToTable("vendas", (string)null);
                });

            modelBuilder.Entity("Vendas.Domain.Aggregates.VendaItem", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<long>("Id"));

                    b.Property<string>("Descricao")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("ImageUrl")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Nome")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<decimal>("Preco")
                        .HasColumnType("numeric");

                    b.Property<int>("Quantidade")
                        .HasColumnType("integer");

                    b.Property<string>("UnidadeMedida")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<long>("VendaId")
                        .HasColumnType("bigint");

                    b.HasKey("Id");

                    b.HasIndex("VendaId");

                    b.ToTable("VendaItens");
                });

            modelBuilder.Entity("Vendas.Domain.Aggregates.Pagamento.Pagamento", b =>
                {
                    b.HasOne("Vendas.Domain.Aggregates.Comprador", "Comprador")
                        .WithMany()
                        .HasForeignKey("CompradorId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Comprador");
                });

            modelBuilder.Entity("Vendas.Domain.Aggregates.Venda", b =>
                {
                    b.HasOne("Vendas.Domain.Aggregates.Comprador", "Comprador")
                        .WithMany()
                        .HasForeignKey("CompradorId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("Vendas.Domain.Aggregates.Pagamento.Pagamento", null)
                        .WithMany("Vendas")
                        .HasForeignKey("PagamentoId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.Navigation("Comprador");
                });

            modelBuilder.Entity("Vendas.Domain.Aggregates.VendaItem", b =>
                {
                    b.HasOne("Vendas.Domain.Aggregates.Venda", "Venda")
                        .WithMany("VendaItens")
                        .HasForeignKey("VendaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Venda");
                });

            modelBuilder.Entity("Vendas.Domain.Aggregates.Pagamento.Pagamento", b =>
                {
                    b.Navigation("Vendas");
                });

            modelBuilder.Entity("Vendas.Domain.Aggregates.Venda", b =>
                {
                    b.Navigation("VendaItens");
                });
#pragma warning restore 612, 618
        }
    }
}