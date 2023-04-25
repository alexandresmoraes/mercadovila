using System.ComponentModel.DataAnnotations;

namespace Auth.API.Models
{
  public class NovoUsuario
  {
    [Required(ErrorMessage = "Nome de Usuário está vazio.")]
    public string? Username { get; set; }

    [Required(ErrorMessage = "Email do Usuário está vazio.")]
    [EmailAddress(ErrorMessage = "Endereço de email inválido.")]
    public string? Email { get; set; }

    [Required(ErrorMessage = "Password está vazio.")]
    [StringLength(100, ErrorMessage = "Senha deve ter entra 4 a 100 caracteres.", MinimumLength = 4)]
    public string? Password { get; set; }

    [Compare("Password", ErrorMessage = "The password must match.")]
    public string? ConfirmPassword { get; set; }
  }
}
