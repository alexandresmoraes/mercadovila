using Common.WebAPI.Shared;

namespace Vendas.Domain.Aggregates
{
  public class Comprador : Entity, IAggregateRoot
  {
    public string UserId { get; set; } = null!;
    public string Nome { get; set; } = null!;
  }
}