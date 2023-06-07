using Microsoft.AspNetCore.Identity;

namespace Auth.API.Data.Entities
{
  public class ApplicationUser : IdentityUser<string>
  {
    public string Nome { get; set; } = null!;
    public bool IsAtivo { get; set; }
    public string? FotoUrl { get; set; }
  }
}
