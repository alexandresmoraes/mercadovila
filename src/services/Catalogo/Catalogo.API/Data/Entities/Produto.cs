﻿using MongoDB.Bson.Serialization.Attributes;
using Newtonsoft.Json;

namespace Catalogo.API.Data.Entities
{
  public class Produto
  {
    [JsonProperty("_id")]
    [BsonId]
    public string Id { get; set; } = Guid.NewGuid().ToString();

    public string Nome { get; set; } = null!;

    public decimal Preco { get; set; }

    public string UnidadeMedida { get; set; } = null!;

    public string Descricao { get; set; } = null!;

    public string CodigoBarras { get; set; } = null!;

    public int Estoque { get; set; }

    public int EstoqueAlvo { get; set; }

    public double Rating { get; set; }

    public int RatingCount { get; set; }

    public DateTime? DataUltimaCompra { get; set; }

    public DateTime DataCriacao { get; set; }

    public bool IsAtivo { get; set; }
  }
}