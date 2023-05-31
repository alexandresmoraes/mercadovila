using Microsoft.AspNetCore.Identity;

namespace Auth.API.Data.Entities
{
  public class ApplicationUser : IdentityUser<string>
  {
    public bool IsActive { get; set; }
  }
}
