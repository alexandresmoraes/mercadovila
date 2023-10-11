using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using GrpcVendas;
using MediatR;
using Vendas.API.Application.Responses;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public class CriarVendaCommandHandler
    : IRequestHandler<CriarVendaCommand, Result<CriarVendaCommandResponse>>
  {
    private readonly ICompradorRepository _compradorRepository;
    private readonly IVendaRepository _vendaRepository;
    private readonly IAuthService _authService;
    private readonly Carrinho.CarrinhoClient _carrinhoClient;

    public CriarVendaCommandHandler(ICompradorRepository compradorRepository, IVendaRepository vendaRepository, IAuthService authService, Carrinho.CarrinhoClient carrinhoClient)
    {
      _compradorRepository = compradorRepository;
      _vendaRepository = vendaRepository;
      _authService = authService;
      _carrinhoClient = carrinhoClient;
    }

    public async Task<Result<CriarVendaCommandResponse>> Handle(CriarVendaCommand request, CancellationToken cancellationToken)
    {
      var userId = _authService.GetUserId();

      var carrinhoRequest = new CarrinhoRequest { UserId = userId };
      var carrinho = await _carrinhoClient.GetCarrinhoPorUsuarioAsync(carrinhoRequest);

      var countIndisponiveis = carrinho.Itens.Count(_ => _.DisponibilidadeEstoque == false);
      if (countIndisponiveis > 0)
      {
        var failMessage = countIndisponiveis > 1 ? "Itens indisponíveis, confira o carrinho." : "Item indisponível, confira o carrinho.";
        return Result.Fail<CriarVendaCommandResponse>(failMessage);
      }

      var comprador = await _compradorRepository.GetAsync(userId) ?? new Comprador(userId, request.CompradorNome);

      var venda = new Venda(
        comprador: comprador,
        vendaItens: carrinho.Itens.Select(item => new VendaItem(
          item.Id,
          item.Nome,
          item.ImageUrl,
          item.Descricao,
          (decimal)item.Preco,
          item.Quantidade,
          item.UnidadeMedida
        )),
        status: EnumVendaStatus.PendentePagamento
      );

      await _vendaRepository.AddAsync(venda);

      return Result.Ok(new CriarVendaCommandResponse
      {
        Id = venda.Id,
      });
    }
  }
}