namespace Compras.API.Application.Queries
{
  public record CompraItemto
  {
    public string ProdutoId { get; init; } = null!;
    public string Nome { get; init; } = null!;
    public string Descricao { get; set; } = null!;
    public string ImageUrl { get; init; } = null!;
    public decimal PrecoPago { get; init; }
    public int Quantidade { get; init; }
    public string UnidadeMedida { get; init; } = null!;
  }

  public record CompraDto
  {
    public long Id { get; init; }
    public DateTimeOffset DataHora { get; init; }
    public decimal Total { get; init; }
    public string UsuarioId { get; init; } = null!;
    public string UsuarioNome { get; init; } = null!;
    public string UsuarioEmail { get; init; } = null!;
    public string? UsuarioFotoUrl { get; init; }

    public List<CompraItemto> Itens { get; init; } = new List<CompraItemto>();
  }

  public record CompraItemDetalheDto
  {
    public string ProdutoId { get; init; } = null!;
    public string Nome { get; init; } = null!;
    public string Descricao { get; set; } = null!;
    public string ImageUrl { get; init; } = null!;
    public decimal PrecoPago { get; init; }
    public decimal PrecoSugerido { get; init; }
    public bool IsPrecoMedioSugerido { get; init; }
    public int Quantidade { get; init; }
    public string UnidadeMedida { get; init; } = null!;
  }

  public record CompraDetalheDto
  {
    public long Id { get; init; }
    public DateTimeOffset DataHora { get; set; }
    public decimal Total { get; init; }
    public string UsuarioId { get; init; } = null!;
    public string UsuarioNome { get; init; } = null!;
    public string UsuarioEmail { get; init; } = null!;
    public string UsuarioFotoUrl { get; init; } = null!;

    public List<CompraItemDetalheDto> Itens { get; init; } = new List<CompraItemDetalheDto>();
  }
}