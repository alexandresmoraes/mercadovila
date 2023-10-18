﻿// <auto-generated />
using System;
using Common.EventBus.Integrations;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Vendas.Infra.IntegrationMigrations
{
    [DbContext(typeof(IntegrationEventContext))]
    [Migration("20231018185728_Initial_Create")]
    partial class Initial_Create
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.12")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("Common.EventBus.Integrations.IntegrationEventLog", b =>
                {
                    b.Property<string>("EventId")
                        .HasColumnType("text")
                        .HasColumnName("entity_id");

                    b.Property<string>("Content")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("content");

                    b.Property<DateTime>("CreationTime")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("creation_time");

                    b.Property<string>("EventTypeName")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("event_type_name");

                    b.Property<int>("State")
                        .HasColumnType("integer")
                        .HasColumnName("state");

                    b.Property<int>("TimesSent")
                        .HasColumnType("integer")
                        .HasColumnName("times_sent");

                    b.Property<string>("TransactionId")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("transaction_id");

                    b.HasKey("EventId");

                    b.ToTable("integration_event", (string)null);
                });
#pragma warning restore 612, 618
        }
    }
}
