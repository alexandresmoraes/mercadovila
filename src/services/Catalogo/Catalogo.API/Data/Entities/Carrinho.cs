using MongoDB.Bson.Serialization.Attributes;

namespace Catalogo.API.Data.Entities
{
  public class Carrinho
  {
    [BsonId]
    public string UserId { get; set; } = null!;

    public IEnumerable<CarrinhoItem> Items { get; set; } = new List<CarrinhoItem>();
  }
}