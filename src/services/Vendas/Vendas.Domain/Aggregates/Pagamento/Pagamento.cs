using Common.WebAPI.Shared;
using System.Text.Json;

namespace Vendas.Domain.Aggregates
{
  public class Pagamento : Entity, IAggregateRoot
  {
    public Comprador Comprador { get; set; } = null!;

    private readonly List<Venda> _vendas = new();
    public IReadOnlyCollection<Venda> Vendas => _vendas;

    public EnumTipoPagamento Tipo { get; set; }
    public decimal Valor { get; set; }
    public DateTime DataHora { get; set; }

    public Pagamento() { }

    public Pagamento(Comprador comprador, IEnumerable<Venda> vendas, EnumTipoPagamento tipo)
    {
      Comprador = comprador;
      _vendas = vendas.ToList();
      Tipo = tipo;
      Valor = vendas.Sum(_ => _.Total);
      DataHora = DateTime.UtcNow;
    }

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}