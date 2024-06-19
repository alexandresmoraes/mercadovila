namespace Vendas.API.Application.Queries
{
  public record VendaQuery
  {
    public int page { get; init; }

    public int limit { get; init; }
    public string? compradorNome { get; set; }

    public DateTime? dataInicial { get; init; }

    public DateTime? dataFinal { get; init; }
  }
}
