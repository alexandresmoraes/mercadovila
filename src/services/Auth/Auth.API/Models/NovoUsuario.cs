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
    [StringLength(50, ErrorMessage = "Senha deve ter entra 4 a 50 caracteres.", MinimumLength = 4)]
    public string? Password { get; set; }

    [Compare("Password", ErrorMessage = "Confirmação de senha não confere.")]
    public string? ConfirmPassword { get; set; }
  }
}