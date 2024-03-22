using System.ComponentModel.DataAnnotations;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Queries
{
  public record PagamentoDetalheDto
  {
    public string CompradorUserId { get; init; } = null!;
    public string CompradorNome { get; init; } = null!;
    public string? CompradorFotoUrl { get; init; }
    public decimal Total { get; init; } = 0;
    public List<PagamentoDetalheVendaDto> Vendas { get; init; } = new List<PagamentoDetalheVendaDto>();
  }

  public record PagamentoDetalheVendaDto
  {
    public long VendaId { get; init; }
    public EnumVendaStatus Status { get; init; }
    public DateTimeOffset DataHora { get; init; }
    public decimal Total { get; init; }
  }

  public record PagamentosDto
  {
    public string CompradorUserId { get; init; } = null!;
    public string CompradorNome { get; init; } = null!;
    public string? CompradorFotoUrl { get; init; }
    public string CompradorEmail { get; init; } = null!;
    public long PagamentoId { get; init; }
    public DateTimeOffset PagamentoDataHora { get; init; }
    public EnumTipoPagamento PagamentoTipo { get; init; }
    public EnumStatusPagamento PagamentoStatus { get; init; }
    public EnumMesReferencia MesReferencia { get; init; }
    public decimal PagamentoValor { get; set; }
    public string RecebidoPorUserId { get; init; } = null!;
    public string RecebidoPor { get; init; } = null!;
    public DateTimeOffset? DataCancelamento { get; init; }
    public string? CanceladoPorUserId { get; init; }
    public string? CanceladoPor { get; init; }
  }

  public record PagamentosQuery
  {
    [Range(1, int.MaxValue, ErrorMessage = "page: mínimo {1}, máximo {2}.")]
    public int page { get; set; }

    [Range(5, 50, ErrorMessage = "limit: mínimo {1}, máximo {2}.")]
    public int limit { get; set; }

    public string? username { get; set; }
  }

  public record MeusPagamentosQuery
  {
    [Range(1, int.MaxValue, ErrorMessage = "page: mínimo {1}, máximo {2}.")]
    public int page { get; set; }

    [Range(5, 50, ErrorMessage = "limit: mínimo {1}, máximo {2}.")]
    public int limit { get; set; }

    public string? userId { get; set; }
  }
}