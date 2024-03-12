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
    public string UsuarioId { get; private set; } = null!;
    public string UsuarioNome { get; private set; } = null!;
    public string UsuarioUsername { get; private set; } = null!;
    public string UsuarioEmail { get; private set; } = null!;
    public string? UsuarioFotoUrl { get; private set; }

    public Compra() { }

    public Compra(List<CompraItem> compraItens, string usuarioId, string usuarioNome, string usuarioUsername, string usuarioEmail, string? usuarioFotoUrl)
    {
      _compraItens = compraItens;
      Total = compraItens.Sum(_ => _.PrecoPago * _.Quantidade);
      DataHora = DateTimeOffset.UtcNow;
      UsuarioId = usuarioId;
      UsuarioNome = usuarioNome;
      UsuarioUsername = usuarioUsername;
      UsuarioEmail = usuarioEmail;
      UsuarioFotoUrl = usuarioFotoUrl;

      AddDomainEvent(new CompraCriadaEvent(this));
    }

    public override string ToString()
    {
      return $"Compra {Id} / " +
        $"DataHora {DataHora} / " +
        $"Total {Total} " +
        $"Usuario {UsuarioNome} / " +
        $"UsuarioEmail {UsuarioEmail}";
    }
  }
}