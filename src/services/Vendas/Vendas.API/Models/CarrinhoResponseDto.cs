namespace Vendas.API.Models
{
  public record CarrinhoUsuarioResponseDto
  {
    public string UserId { get; set; } = null!;
    public List<CarrinhoItemResponseDto> Itens { get; set; } = new();
  }

  public record CarrinhoItemResponseDto
  {
    public string Id { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string ImageUrl { get; set; } = null!;
    public string Descricao { get; set; } = null!;
    public decimal Preco { get; set; }
    public int Quantidade { get; set; }
    public string UnidadeMedida { get; set; } = null!;
    public bool DisponibilidadeEstoque { get; set; }
  }
}
