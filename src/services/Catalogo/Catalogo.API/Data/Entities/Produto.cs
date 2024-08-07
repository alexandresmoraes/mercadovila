﻿using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json;

namespace Catalogo.API.Data.Entities
{
  public class Produto
  {
    [BsonId]
    public string Id { get; set; } = Guid.NewGuid().ToString();

    public string ImageUrl { get; set; } = null!;

    public string Nome { get; set; } = null!;

    public string Descricao { get; set; } = null!;

    public decimal Preco { get; set; }

    public string UnidadeMedida { get; set; } = null!;

    public string CodigoBarras { get; set; } = null!;

    public int EstoqueAlvo { get; set; }

    public int Estoque { get; set; }

    public double Rating { get; set; }

    public int RatingCount { get; set; }

    public DateTimeOffset? DataUltimaVenda { get; set; }

    public int QuantidadeVendida { get; set; }

    public DateTimeOffset DataCriacao { get; set; } = DateTimeOffset.UtcNow;

    public bool IsAtivo { get; set; }

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}