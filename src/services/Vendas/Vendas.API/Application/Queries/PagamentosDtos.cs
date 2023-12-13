using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Queries
{
  public record PagamentoDetalheDto
  {
    public string CompradorUserId { get; init; } = null!;
    public string? CompradorNome { get; init; } = null!;
    public string? CompradorFotoUrl { get; init; }
    public decimal Total { get; init; } = 0;
    public List<PagamentoDetalheVendaDto> Vendas { get; init; } = new List<PagamentoDetalheVendaDto>();
  }

  public record PagamentoDetalheVendaDto
  {
    public long VendaId { get; init; }
    public EnumVendaStatus Status { get; init; }
    public DateTime DataHora { get; init; }
    public decimal Total { get; init; }
  }
}