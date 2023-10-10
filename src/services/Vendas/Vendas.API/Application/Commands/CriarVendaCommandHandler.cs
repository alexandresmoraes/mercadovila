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
    private readonly Catalogo.CatalogoClient _catalogoClient;

    public CriarVendaCommandHandler(ICompradorRepository compradorRepository, IVendaRepository vendaRepository, IAuthService authService, Catalogo.CatalogoClient catalogoClient)
    {
      _compradorRepository = compradorRepository;
      _vendaRepository = vendaRepository;
      _authService = authService;
      _catalogoClient = catalogoClient;
    }

    public async Task<Result<CriarVendaCommandResponse>> Handle(CriarVendaCommand request, CancellationToken cancellationToken)
    {
      var userId = _authService.GetUserId();

      var carrinhoRequest = new CarrinhoRequest { UserId = userId };
      var carrinho = await _catalogoClient.GetCarrinhoPorUsuarioAsync(carrinhoRequest);

      var comprador = await _compradorRepository.GetAsync(userId) ?? new Comprador(userId, request.CompradorNome);

      if (carrinho.Itens.Any(_ => _.DisponibilidadeEstoque == false))
        return Result.Fail<CriarVendaCommandResponse>("Produto(s) fora de estoque");

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