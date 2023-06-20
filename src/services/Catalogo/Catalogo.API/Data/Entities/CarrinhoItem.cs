using MongoDB.Bson.Serialization.Attributes;

namespace Catalogo.API.Data.Entities
{
  public class CarrinhoItem
  {
    [BsonId]
    public string ProdutoId { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public int Quantidade { get; set; }
  }
}