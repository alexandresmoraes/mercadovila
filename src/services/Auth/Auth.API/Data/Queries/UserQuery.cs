using System.ComponentModel.DataAnnotations;

namespace Auth.API.Data.Queries
{
  public record UserQuery
  {
    [Range(0, int.MaxValue, ErrorMessage = "start: mínimo {1}, máximo {2}.")]
    public int start { get; set; }
    [Range(5, 50, ErrorMessage = "limit: mínimo {1}, máximo {2}.")]
    public int limit { get; set; }
    public string? username { get; set; }
  }
}
