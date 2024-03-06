using Common.WebAPI.Shared;
using Compras.Domain.Events;

namespace Compras.Domain.Aggregates
{
  public class Compra : Entity, IAggregateRoot
  {
    private readonly List<CompraItem> _compraItens = new List<CompraItem>();
    public IReadOnlyCollection<CompraItem> CompraItens => _compraItens;
    public DateTimeOffset DataHora { get; private set; }
    public decimal Total { get; private set; }
    public string UserId { get; private set; } = null!;
    public string UserEmail { get; private set; } = null!;

    public Compra() { }

    public Compra(IEnumerable<CompraItem> vendaItens, string userId, string userEmail)
    {
      _compraItens = vendaItens.ToList();
      Total = vendaItens.Sum(_ => _.PrecoPago * _.Quantidade);
      DataHora = DateTimeOffset.UtcNow;
      UserId = userId;
      UserEmail = userEmail;

      AddDomainEvent(new CompraCriadaEvent(this));
    }

    public override string ToString()
    {
      return $"Compra {Id} / " +
        $"DataHora {DataHora} / " +
        $"Total {Total} " +
        $"UserEmail {UserEmail}";
    }
  }
}