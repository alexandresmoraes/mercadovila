using System.ComponentModel.DataAnnotations;

namespace Auth.API.Models
{
  public class LoginModel
  {
    [Required(ErrorMessage = "Nome de usuário ou email está vazio")]
    public string? UsernameOrEmail { get; set; }

    [Required(ErrorMessage = "Senha está vazio.")]
    [StringLength(50, ErrorMessage = "Senha deve ter entra 4 a 50 caracteres.", MinimumLength = 4)]
    public string? Password { get; set; }
  }
}
