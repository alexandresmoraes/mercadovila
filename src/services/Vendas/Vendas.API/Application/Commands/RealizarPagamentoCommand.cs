using Common.WebAPI.Results;
using MediatR;
using Vendas.API.Application.Responses;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public record RealizarPagamentoCommand : IRequest<Result<RealizarPagamentoCommandResponse>>
  {
    public string UserId { get; set; } = null!;
    public EnumTipoPagamento TipoPagamento { get; set; }
    public IEnumerable<long> VendasId { get; set; } = Enumerable.Empty<long>();    
  }
}