using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json;

namespace Catalogo.API.Data.Entities
{
  public class FavoritoItem
  {
    [BsonId]
    public string Id { get; set; } = Guid.NewGuid().ToString();

    public string UserId { get; set; } = null!;

    public string ProdutoId { get; set; } = null!;

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}