namespace Catalogo.API.Data.Dto
{
  public record ProdutoDto
  {
    public string Id { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string Descricao { get; set; } = null!;
    public string FotoUrl { get; set; } = null!;
    public decimal Preco { get; set; }
    public string UnidadeMedida { get; set; } = null!;
    public int EstoqueAlvo { get; set; }
    public int Estoque { get; set; }
    public double Rating { get; set; }
    public int RatingCount { get; set; }
    public bool IsAtivo { get; set; }
  }
}