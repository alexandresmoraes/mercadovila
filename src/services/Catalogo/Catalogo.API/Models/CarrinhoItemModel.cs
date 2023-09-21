using System.ComponentModel.DataAnnotations;

namespace Catalogo.API.Models
{
  public class CarrinhoItemModel
  {
    [Required(ErrorMessage = "A quantidade mínima é 1.")]
    [Range(1, int.MaxValue, ErrorMessage = "A quantidade mínima é 1.")]
    public int quantidade { get; set; }

    [Required(ErrorMessage = "Produto está vazio.")]
    public string produtoId { get; set; } = null!;
  }
}
