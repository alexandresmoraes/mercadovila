using MongoDB.Bson.Serialization.Attributes;

namespace Catalogo.API.Data.Entities
{
  public class RatingItem
  {
    [BsonId]
    public string Id { get; set; } = Guid.NewGuid().ToString();

    public string ProdutoId { get; set; } = null!;

    public long VendaId { get; set; }

    public short Rating { get; set; }
  }
}
