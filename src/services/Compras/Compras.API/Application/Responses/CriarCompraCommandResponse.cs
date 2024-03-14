namespace Compras.API.Application.Responses
{
  public record CriarCompraCommandResponse
  {
    public long Id { get; private init; }

    public CriarCompraCommandResponse(long id)
    {
      Id = id;
    }
  }
}