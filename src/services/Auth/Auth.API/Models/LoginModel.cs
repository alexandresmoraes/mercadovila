using System.ComponentModel.DataAnnotations;

namespace Auth.API.Models
{
  public record LoginModel
  {
    [Required(ErrorMessage = "Nome de usuário ou email está vazio")]
    public string? UsernameOrEmail { get; set; }

    [Required(ErrorMessage = "Senha está vazio.")]
    public string? Password { get; set; }

    public override string ToString()
    {
      return $"{nameof(UsernameOrEmail)}: {UsernameOrEmail}, {nameof(Password)}: {Password}";
    }
  }
}
