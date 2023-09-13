using System.ComponentModel.DataAnnotations;

namespace Catalogo.API.Data.Queries
{
  public record CatalogoTodosQuery
  {
    [Range(1, int.MaxValue, ErrorMessage = "page: mínimo {1}, máximo {2}.")]
    public int page { get; set; }

    [Range(5, 50, ErrorMessage = "limit: mínimo {1}, máximo {2}.")]
    public int limit { get; set; }

    [Range(0, 3, ErrorMessage = "order fora do range, 0 a 3.")]
    public ECatalogoTodosQueryOrder order { get; set; }

    public bool inStock { get; set; }

    public bool outOfStock { get; set; }
  }

  public enum ECatalogoTodosQueryOrder
  {
    NameAsc,
    NameDesc,
    PriceHighToLow,
    PriceLowToHigh
  }
}
