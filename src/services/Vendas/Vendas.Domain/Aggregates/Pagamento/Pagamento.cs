using Common.WebAPI.Shared;

namespace Vendas.Domain.Aggregates
{
  public class Pagamento : Entity, IAggregateRoot
  {
    public Comprador Comprador { get; private set; } = null!;

    private readonly List<Venda> _vendas = new();
    public IReadOnlyCollection<Venda> Vendas => _vendas;

    public EnumTipoPagamento Tipo { get; private set; }
    public EnumStatusPagamento Status { get; private set; }
    public decimal Valor { get; private set; }
    public DateTime DataHora { get; private set; }

    public Pagamento() { }

    public Pagamento(Comprador comprador, IEnumerable<Venda> vendas, EnumTipoPagamento tipo)
    {
      Comprador = comprador;
      _vendas = vendas.ToList();
      Tipo = tipo;
      Valor = vendas.Sum(_ => _.Total);
      DataHora = DateTime.UtcNow;
      Status = EnumStatusPagamento.Ativo;

      _vendas.ForEach(venda => venda.RealizarPagamento());
    }

    public void Cancelar()
    {
      Status = EnumStatusPagamento.Cancelado;

      foreach (var venda in _vendas)
      {
        venda.CancelarPagamento();
      }

      _vendas.Clear();
    }

    public override string ToString()
    {
      return $"Pagamento {Id} / " +
        $"Comprador {Comprador?.Nome} / " +
        $"Status {Status} / " +
        $"DataHora {DataHora} / " +
        $"Valor {Valor}";
    }
  }
}