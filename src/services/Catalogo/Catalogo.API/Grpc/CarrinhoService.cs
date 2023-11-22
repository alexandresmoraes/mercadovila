using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Repositories;
using Grpc.Core;
using Microsoft.AspNetCore.Authorization;

namespace GrpcCatalogo;

public class CarrinhoService : Carrinho.CarrinhoBase
{
  private readonly ILogger<CarrinhoService> _logger;
  private readonly ICarrinhoItemRepository _carrinhoItemRepository;
  private readonly IProdutoRepository _produtoRepository;

  public CarrinhoService(ILogger<CarrinhoService> logger, ICarrinhoItemRepository carrinhoItemRepository, IProdutoRepository produtoRepository)
  {
    _logger = logger;
    _carrinhoItemRepository = carrinhoItemRepository;
    _produtoRepository = produtoRepository;
  }

  [AllowAnonymous]
  public override async Task<CarrinhoResponse> GetCarrinhoReservarEstoquePorUsuario(CarrinhoRequest request, ServerCallContext context)
  {
    _logger.LogInformation("Begin grpc call from method {Method} for user id {UserId}", context.Method, request.UserId);

    var carrinho = await _carrinhoItemRepository.GetCarrinhoPorUsuarioAsync(request.UserId);

    var response = MapToCarrinhoResponse(request.UserId, carrinho);

    if (response.Itens.Any() && !response.Itens.Any(_ => _.DisponibilidadeEstoque == false))
    {
      await _produtoRepository.UpdateReservarEstoque(response.Itens.ToDictionary(_ => _.Id, _ => _.Quantidade));
    }

    return response;
  }

  private static CarrinhoResponse MapToCarrinhoResponse(string userId, CarrinhoDto dto)
  {
    var map = new CarrinhoResponse
    {
      UserId = userId,
    };

    dto.Itens.ToList().ForEach(item => map.Itens.Add(new CarrinhoItemResponse
    {
      Id = item.ProdutoId,
      Nome = item.Nome,
      Descricao = item.Descricao,
      ImageUrl = item.ImageUrl,
      Preco = decimal.ToDouble(item.Preco),
      Quantidade = item.Quantidade,
      UnidadeMedida = item.UnidadeMedida,
      DisponibilidadeEstoque = !item.IsAtivo || item.Estoque >= item.Quantidade
    }));

    return map;
  }
}