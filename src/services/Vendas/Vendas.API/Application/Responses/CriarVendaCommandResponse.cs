namespace Vendas.API.Application.Responses
{
  public record CriarVendaCommandResponse
  {
    public long Id { get; private init; }

    public CriarVendaCommandResponse(long id)
    {
      Id = id;
    }
  }
}
