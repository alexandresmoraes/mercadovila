using Common.WebAPI.Results;
using Compras.API.Application.Responses;
using MediatR;

namespace Compras.API.Application.Commands
{
  public record CriarCompraCommand : IRequest<Result<CriarCompraCommandResponse>>
  {
    public string UsuarioNome { get; private init; }
    public string? UsuarioFotoUrl { get; private init; }

    public IEnumerable<CriarComparItemCommand> CompraItens { get; private init; }

    public CriarCompraCommand(string usuarioNome, string? usuarioFotoUrl, IEnumerable<CriarComparItemCommand> compraItens)
    {
      UsuarioNome = usuarioNome;
      UsuarioFotoUrl = usuarioFotoUrl;
      CompraItens = compraItens;
    }
  }

  public record CriarComparItemCommand
  {
    public string ProdutoId { get; private set; } = null!;
    public string Nome { get; private set; } = null!;
    public string ImageUrl { get; private set; } = null!;
    public string Descricao { get; private set; } = null!;
    public int EstoqueAtual { get; set; }
    public decimal PrecoPago { get; private set; }
    public decimal PrecoSugerido { get; private set; }
    public bool IsPrecoMedioSugerido { get; private set; }
    public int Quantidade { get; private set; }
    public string UnidadeMedida { get; private set; } = null!;

    public CriarComparItemCommand(string produtoId, string nome, string imageUrl, string descricao, int estoqueAtual, decimal precoPago, decimal precoSugerido, bool isPrecoMedioSugerido, int quantidade, string unidadeMedida)
    {
      ProdutoId = produtoId;
      Nome = nome;
      ImageUrl = imageUrl;
      Descricao = descricao;
      EstoqueAtual = estoqueAtual;
      PrecoPago = precoPago;
      PrecoSugerido = precoSugerido;
      IsPrecoMedioSugerido = isPrecoMedioSugerido;
      Quantidade = quantidade;
      UnidadeMedida = unidadeMedida;
    }
  }
}