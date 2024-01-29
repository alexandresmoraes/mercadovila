using Common.WebAPI.Results;
using MediatR;
using Vendas.API.Application.Responses;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public class RealizarPagamentoCommandHandler
    : IRequestHandler<RealizarPagamentoCommand, Result<RealizarPagamentoCommandResponse>>
  {
    private readonly IPagamentosRepository _pagamentosRepository;
    private readonly IVendasRepository _vendasRepository;
    private readonly ICompradoresRepository _compradoresRepository;

    public RealizarPagamentoCommandHandler(IPagamentosRepository pagamentosRepository, IVendasRepository vendasRepository, ICompradoresRepository compradoresRepository)
    {
      _pagamentosRepository = pagamentosRepository;
      _vendasRepository = vendasRepository;
      _compradoresRepository = compradoresRepository;
    }

    public async Task<Result<RealizarPagamentoCommandResponse>> Handle(RealizarPagamentoCommand request, CancellationToken cancellationToken)
    {
      cancellationToken.ThrowIfCancellationRequested();

      var comprador = await _compradoresRepository.GetAsync(request.UserId);
      if (comprador is null)
        return Result.Fail<RealizarPagamentoCommandResponse>($"Comprador {request.UserId} não encontrado.");

      var vendas = new List<Venda>();
      foreach (var vendaId in request.VendasId)
      {
        var venda = await _vendasRepository.GetAsync(vendaId);

        if (venda is null)
          return Result.Fail<RealizarPagamentoCommandResponse>($"Venda #{vendaId} não encontrada.");

        if (venda.Comprador.UserId != request.UserId)
          return Result.Fail<RealizarPagamentoCommandResponse>($"Venda #{vendaId} não é do usuário {request.UserId}.");

        if (venda.Status != EnumVendaStatus.PendentePagamento)
          return Result.Fail<RealizarPagamentoCommandResponse>($"Venda #{vendaId} não encontra-se Pendente de Pagamento.");

        vendas.Add(venda!);
      }

      var pagamento = new Pagamento(comprador, vendas, request.TipoPagamento);

      pagamento.RealizarPagamento();

      await _pagamentosRepository.AddAsync(pagamento);

      return Result.Ok(new RealizarPagamentoCommandResponse
      {
        Id = pagamento.Id
      });
    }
  }
}