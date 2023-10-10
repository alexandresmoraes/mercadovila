using Catalogo.API.Data.Dto;
using Catalogo.API.Data.Repositories;
using Grpc.Core;
using Microsoft.AspNetCore.Authorization;

namespace GrpcCatalogo;

public class CarrinhoService : Catalogo.CatalogoBase
{
  private readonly ILogger<CarrinhoService> _logger;
  private readonly ICarrinhoItemRepository _carrinhoItemRepository;

  public CarrinhoService(ILogger<CarrinhoService> logger, ICarrinhoItemRepository carrinhoItemRepository)
  {
    _logger = logger;
    _carrinhoItemRepository = carrinhoItemRepository;
  }

  [AllowAnonymous]
  public override async Task<CarrinhoUsuarioResponse> GetCarrinhoPorUsuario(CarrinhoRequest request, ServerCallContext context)
  {
    _logger.LogInformation("Begin grpc call from method {Method} for user id {UserId}", context.Method, request.UserId);

    var carrinho = await _carrinhoItemRepository.GetCarrinhoPorUsuarioAsync(request.UserId);

    return MapToCarrinhoUsuarioResponse(request.UserId, carrinho);
  }

  private CarrinhoUsuarioResponse MapToCarrinhoUsuarioResponse(string userId, CarrinhoDto dto)
  {
    var map = new CarrinhoUsuarioResponse
    {
      UserId = userId,
    };

    dto.Itens.ToList().ForEach(item => map.Itens.Add(new CarrinhoItemResponse
    {
      Id = item.Id,
      Nome = item.Nome,
      Descricao = item.Descricao,
      Preco = decimal.ToDouble(item.Preco),
      Quantidade = item.Quantidade,
      UnidadeMedida = item.UnidadeMedida,
      DisponibilidadeEstoque = item.Estoque >= item.Quantidade
    }));

    return map;
  }
}