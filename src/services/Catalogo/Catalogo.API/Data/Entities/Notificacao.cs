using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json;

namespace Catalogo.API.Data.Entities
{
  public class Notificacao
  {
    [BsonId]
    public string Id { get; set; } = Guid.NewGuid().ToString();

    public string Titulo { get; set; } = null!;

    public string Mensagem { get; set; } = null!;

    public string? ImageUrl { get; set; }

    public DateTime DataCriacao { get; set; } = DateTime.UtcNow;

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}

