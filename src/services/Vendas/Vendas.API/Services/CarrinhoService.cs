using GrpcVendas;
using Vendas.API.Models;

namespace Vendas.API.Services
{
  public class CarrinhoService : ICarrinhoService
  {
    private readonly Carrinho.CarrinhoClient _carrinhoClient;
    private readonly ILogger<CarrinhoService> _logger;

    public CarrinhoService(Carrinho.CarrinhoClient carrinhoClient, ILogger<CarrinhoService> logger)
    {
      _carrinhoClient = carrinhoClient;
      _logger = logger;
    }

    public async Task<CarrinhoUsuarioResponseDto?> GetCarrinhoPorUsuario(string userId)
    {
      _logger.LogDebug("grpc client created, request = {@id}", userId);
      var request = new CarrinhoRequest { UserId = userId };
      var response = await _carrinhoClient.GetCarrinhoReservarEstoquePorUsuarioAsync(request);
      _logger.LogDebug("grpc response {@response}", response);

      return MapToCarrinhoDto(response);
    }

    private static CarrinhoUsuarioResponseDto? MapToCarrinhoDto(CarrinhoResponse response)
    {
      if (response is null)
      {
        return null;
      }

      var map = new CarrinhoUsuarioResponseDto
      {
        UserId = response.UserId,
      };

      response.Itens.ToList().ForEach(item => map.Itens.Add(new CarrinhoItemResponseDto
      {
        Id = item.Id,
        Nome = item.Nome,
        ImageUrl = item.ImageUrl,
        Descricao = item.Descricao,
        Preco = (decimal)item.Preco,
        Quantidade = item.Quantidade,
        UnidadeMedida = item.UnidadeMedida,
        DisponibilidadeEstoque = item.DisponibilidadeEstoque
      }));

      return map;
    }
  }
}
