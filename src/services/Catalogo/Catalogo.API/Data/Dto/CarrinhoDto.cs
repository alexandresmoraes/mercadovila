using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Catalogo.API.Data.Dto
{
  public record CarrinhoDto
  {
    public CarrinhoDto(IEnumerable<CarrinhoItemDto>? itens)
    {
      Itens = itens ?? Enumerable.Empty<CarrinhoItemDto>();
    }

    public IEnumerable<CarrinhoItemDto> Itens { get; set; }
    public decimal Subtotal { get => Itens.Sum(i => i.Preco * i.Quantidade); }
    public decimal Total { get => Subtotal; }

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }

  public record CarrinhoItemDto
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
    public int Quantidade { get; set; }
    public bool IsFavorito { get; set; }
    public decimal Subtotal { get => Preco * Quantidade; }

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}