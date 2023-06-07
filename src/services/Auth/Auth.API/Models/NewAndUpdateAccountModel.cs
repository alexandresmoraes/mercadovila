using System.ComponentModel.DataAnnotations;

namespace Auth.API.Models
{
  public record NewAndUpdateAccountModel
  {
    [Required(ErrorMessage = "Nome do usuário está vazio.")]
    public string? Nome { get; set; }

    [Required(ErrorMessage = "Nome de usuário está vazio.")]
    public string? Username { get; set; }

    [Required(ErrorMessage = "Email do Usuário está vazio.")]
    [EmailAddress(ErrorMessage = "Endereço de email inválido.")]
    public string? Email { get; set; }

    [Required(ErrorMessage = "Senha está vazio.")]
    [StringLength(50, ErrorMessage = "Senha deve ter entra 4 a 50 caracteres.", MinimumLength = 4)]
    public string? Password { get; set; }

    [StringLength(50, ErrorMessage = "Confirmação de senha deve ter entra 4 a 50 caracteres.", MinimumLength = 4)]
    [Compare("Password", ErrorMessage = "Confirmação de senha não confere.")]
    public string? ConfirmPassword { get; set; }

    [Required(ErrorMessage = "Telefone está vazio.")]
    [StringLength(17, ErrorMessage = "Telefone deve ter entra 11 a 17 caracteres.", MinimumLength = 11)]
    public string? Telefone { get; set; }

    public bool IsActive { get; set; }

    public bool IsAdmin { get; set; }
  }

  public record NewAccountResponseModel
  {
    public string Id { get; set; }

    public NewAccountResponseModel(string id)
    {
      Id = id;
    }
  }
}