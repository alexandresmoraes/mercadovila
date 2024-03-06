namespace Compras.API.Application.Queries
{
  public record CompraDto
  {
    public long Id { get; init; }
    public DateTimeOffset DataHora { get; set; }
    public decimal Total { get; init; }
    public string UserId { get; private set; } = null!;
    public string UserEmail { get; private set; } = null!;

    public List<CompraItemto> Itens { get; init; } = new List<CompraItemto>();
  }

  public record CompraItemto
  {
    public string ProdutoId { get; init; } = null!;
    public string Nome { get; init; } = null!;
    public string ImageUrl { get; init; } = null!;
    public decimal PrecoPago { get; init; }
    public int Quantidade { get; init; }
    public string UnidadeMedida { get; init; } = null!;
  }
}