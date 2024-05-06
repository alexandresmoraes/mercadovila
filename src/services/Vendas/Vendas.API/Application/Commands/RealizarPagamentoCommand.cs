using Common.WebAPI.Results;
using MediatR;
using Vendas.API.Application.Responses;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public record RealizarPagamentoCommand : IRequest<Result<RealizarPagamentoCommandResponse>>
  {
    public string? UserId { get; init; }
    public EnumTipoPagamento? TipoPagamento { get; init; }
    public EnumMesReferencia? MesReferencia { get; init; }
    public IEnumerable<long>? VendasId { get; init; }
  }
}