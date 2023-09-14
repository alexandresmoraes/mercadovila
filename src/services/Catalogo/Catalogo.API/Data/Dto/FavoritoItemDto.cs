using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json.Serialization;

namespace Catalogo.API.Data.Dto
{
  public record FavoritoItemDto
  {
    [JsonIgnore]
    [BsonId]
    public string Id { get; set; } = null!;
    public string ProdutoId { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string Descricao { get; set; } = null!;
    public string ImageUrl { get; set; } = null!;
    public decimal Preco { get; set; }
    public string UnidadeMedida { get; set; } = null!;
    public int Estoque { get; set; }
    public double Rating { get; set; }
    public int RatingCount { get; set; }
    public bool IsAtivo { get; set; }
    public bool IsFavorito { get; set; } = true;
  }
}
