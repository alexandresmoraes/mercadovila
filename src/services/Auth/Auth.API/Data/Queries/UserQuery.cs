using System.ComponentModel.DataAnnotations;

namespace Auth.API.Data.Queries
{
  public record UserQuery
  {
    [Range(1, int.MaxValue, ErrorMessage = "page: mínimo {1}, máximo {2}.")]
    public int page { get; set; }

    [Range(5, 50, ErrorMessage = "limit: mínimo {1}, máximo {2}.")]
    public int limit { get; set; }

    public string? username { get; set; }
  }
}
