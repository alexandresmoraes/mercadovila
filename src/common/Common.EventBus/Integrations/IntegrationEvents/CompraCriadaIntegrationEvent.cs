using System.Text.Json.Serialization;

namespace Common.EventBus.Integrations.IntegrationEvents
{
  public record CompraCriadaIntegrationEvent : IntegrationEvent
  {
    public long CompraId { get; private init; }
    public string UserId { get; private init; } = null!;
    public List<VendaCanceladaItemIntegrationEvent> CompraItens { get; private init; }

    public CompraCriadaIntegrationEvent(long compraId, string userId, List<VendaCanceladaItemIntegrationEvent> compraItens)
    {
      CompraId = compraId;
      UserId = userId;
      CompraItens = compraItens;
    }
    [JsonConstructor]
    public CompraCriadaIntegrationEvent(long compraId, string userId, List<VendaCanceladaItemIntegrationEvent> compraItens, string id, DateTimeOffset creationDate, string? key)
      : base(id, creationDate, key)
    {
      CompraId = compraId;
      UserId = userId;
      CompraItens = compraItens;
    }
  }

  public record CompraCriadaItemIntegrationEvent
  {
    public string ProdutoId { get; private init; } = null!;
    public int Quantidade { get; private init; }
    public decimal PrecoPago { get; private init; }
    public decimal? PrecoSugerido { get; private init; }
    public bool IsPrecoSugerido { get; private init; }

    public CompraCriadaItemIntegrationEvent(string produtoId, int quantidade, decimal precoPago, decimal? precoSugerido, bool isPrecoSugerido)
    {
      ProdutoId = produtoId;
      Quantidade = quantidade;
      PrecoPago = precoPago;
      PrecoSugerido = precoSugerido;
      IsPrecoSugerido = isPrecoSugerido;
    }
  }
}