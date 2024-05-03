using Common.WebAPI.Results;
using MediatR;
using Vendas.API.Application.Responses;

namespace Vendas.API.Application.Commands
{
  public record RealizarPagamentoCommand : IRequest<Result<RealizarPagamentoCommandResponse>>
  {
    public string? UserId { get; init; }
    public int? TipoPagamento { get; init; }
    public int? MesReferencia { get; init; }
    public IEnumerable<long>? VendasId { get; init; }
  }
}