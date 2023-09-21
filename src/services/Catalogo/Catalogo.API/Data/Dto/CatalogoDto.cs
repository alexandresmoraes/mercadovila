namespace Catalogo.API.Data.Dto
{
  public record CatalogoDto
  {
    public string ProdutoId { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string Descricao { get; set; } = null!;
    public string UnidadeMedida { get; set; } = null!;
    public string ImageUrl { get; set; } = null!;
    public int Estoque { get; set; }
    public decimal Preco { get; set; }
    public double Rating { get; set; }
    public int RatingCount { get; set; }
    public bool IsAtivo { get; set; }
    public bool IsFavorito { get; set; } = false;
  }
}
