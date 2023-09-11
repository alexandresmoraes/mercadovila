using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json.Serialization;

namespace Catalogo.API.Data.Dto
{
  public record CatalogoDto
  {
    [JsonIgnore]
    [BsonId]
    public string _id { get; set; } = null!;
    public string Id { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string UnidadeMedida { get; set; } = null!;
    public string ImageUrl { get; set; } = null!;
    public int Estoque { get; set; }
    public decimal Preco { get; set; }
    public bool IsAtivo { get; set; }
  }
}
