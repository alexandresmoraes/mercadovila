namespace Catalogo.API.Data.Dto
{
  public record ListaCompraDto
  {
    public string Id { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string Descricao { get; set; } = null!;
    public string ImageUrl { get; set; } = null!;
    public string UnidadeMedida { get; set; } = null!;
    public int EstoqueAlvo { get; set; }
    public int Estoque { get; set; }
    public double Rating { get; set; }
    public int RatingCount { get; set; }
  }
}