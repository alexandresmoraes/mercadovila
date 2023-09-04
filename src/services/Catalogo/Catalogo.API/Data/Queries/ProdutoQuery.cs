using System.ComponentModel.DataAnnotations;

namespace Catalogo.API.Data.Queries
{
  public class ProdutoQuery
  {
    [Range(1, int.MaxValue, ErrorMessage = "page: mínimo {1}, máximo {2}.")]
    public int Page { get; set; }

    [Range(5, 50, ErrorMessage = "limit: mínimo {1}, máximo {2}.")]
    public int Limit { get; set; }

    public string? Nome { get; set; }
  }
}