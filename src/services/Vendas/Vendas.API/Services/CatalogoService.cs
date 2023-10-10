using GrpcVendas;
using Vendas.API.Models;

namespace Vendas.API.Services
{
  public class CatalogoService : ICatalogoService
  {
    private readonly Catalogo.CatalogoClient _catalogoClient;
    private readonly ILogger<CatalogoService> _logger;

    public CatalogoService(Catalogo.CatalogoClient catalogoClient, ILogger<CatalogoService> logger)
    {
      _catalogoClient = catalogoClient;
      _logger = logger;
    }

    public async Task<CarrinhoUsuarioResponseDto?> GetCarrinhoPorUsuario(string userId)
    {
      _logger.LogDebug("grpc client created, request = {@id}", userId);
      var request = new CarrinhoRequest { UserId = userId };
      var response = await _catalogoClient.GetCarrinhoPorUsuarioAsync(request);
      _logger.LogDebug("grpc response {@response}", response);

      return MapToCarrinhoDto(response);
    }

    private CarrinhoUsuarioResponseDto? MapToCarrinhoDto(CarrinhoUsuarioResponse response)
    {
      if (response == null)
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
