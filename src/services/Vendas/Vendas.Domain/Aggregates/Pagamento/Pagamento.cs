using Common.WebAPI.Shared;
using System.Text.Json;

namespace Vendas.Domain.Aggregates.Pagamento
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

    public Pagamento(Comprador comprador, IEnumerable<Venda> vendas, EnumTipoPagamento tipo, decimal valor)
    {
      Comprador = comprador;
      _vendas = vendas.ToList();
      Tipo = tipo;
      Valor = valor;
      DataHora = DateTime.Now;
    }

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}