namespace Compras.API.Application.Queries
{
  public record CompraQuery
  {
    public int page { get; init; }

    public int limit { get; init; }

    public DateTime? dataInicial { get; init; }

    public DateTime? dataFinal { get; init; }
  }
}
