using System.Text.Json.Serialization;

namespace Common.EventBus.Integrations.IntegrationEvents
{
  public record VendaCanceladaIntegrationEvent : IntegrationEvent
  {
    public long VendaId { get; private init; }
    public string UserId { get; private init; }
    public List<VendaCanceladaItemIntegrationEvent> VendaItens { get; private init; }

    public VendaCanceladaIntegrationEvent(long vendaId, string userId, List<VendaCanceladaItemIntegrationEvent> vendaItens)
    {
      VendaId = vendaId;
      UserId = userId;
      VendaItens = vendaItens;
    }

    [JsonConstructor]
    public VendaCanceladaIntegrationEvent(long vendaId, string userId, List<VendaCanceladaItemIntegrationEvent> vendaItens, string id, DateTime creationDate, string? key)
      : base(id, creationDate, key)
    {
      VendaId = vendaId;
      UserId = userId;
      VendaItens = vendaItens;
    }
  }

  public record VendaCanceladaItemIntegrationEvent
  {
    public string ProdutoId { get; private init; } = null!;
    public int Quantidade { get; private init; }
    public decimal Preco { get; private init; }

    public VendaCanceladaItemIntegrationEvent(string produtoId, int quantidade, decimal preco)
    {
      ProdutoId = produtoId;
      Quantidade = quantidade;
      Preco = preco;
    }
  }
}