using System;
using MongoDB.Bson.Serialization.Attributes;

namespace Catalogo.API.Data.Entities
{
  public class Notificacao
  {
    [BsonId]
    public string Id { get; set; } = Guid.NewGuid().ToString();

    public string Mensagem { get; set; } = null!;

    public string? ImageUrl { get; set; }

    public DateTime DataCriacao { get; set; } = DateTime.Now;
  }
}

