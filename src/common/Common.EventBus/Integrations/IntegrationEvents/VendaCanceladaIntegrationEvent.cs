namespace Common.EventBus.Integrations.IntegrationEvents
{
  public record VendaCanceladaIntegrationEvent : IntegrationEvent
  {
    public long VendaId { get; private set; }
    public string UserId { get; private set; }
    private readonly List<VendaCanceladaItemIntegrationEvent> _vendaItens = new List<VendaCanceladaItemIntegrationEvent>();
    public IReadOnlyCollection<VendaCanceladaItemIntegrationEvent> VendaItens => _vendaItens;

    public VendaCanceladaIntegrationEvent(long vendaId, string userId, List<VendaCanceladaItemIntegrationEvent> vendaItens)
    {
      VendaId = vendaId;
      UserId = userId;
      _vendaItens = vendaItens;
    }
  }

  public record VendaCanceladaItemIntegrationEvent : IntegrationEvent
  {
    public string ProdutoId { get; private set; } = null!;
    public int Quantidade { get; private set; }
    public decimal Preco { get; private set; }

    public VendaCanceladaItemIntegrationEvent(string produtoId, int quantidade, decimal preco) : base()
    {
      ProdutoId = produtoId;
      Quantidade = quantidade;
      Preco = preco;
    }
  }
}