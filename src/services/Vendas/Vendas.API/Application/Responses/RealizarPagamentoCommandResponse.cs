namespace Vendas.API.Application.Responses
{
  public record RealizarPagamentoCommandResponse
  {
    public long Id { get; private init; }

    public RealizarPagamentoCommandResponse(long id)
    {
      Id = id;
    }
  }
}