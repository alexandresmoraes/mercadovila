using Common.WebAPI.Validation;
using System.ComponentModel.DataAnnotations;

namespace Catalogo.API.Models
{
  public record ProdutoModel
  {
    [Required(ErrorMessage = "Nome do produto está vazio.")]
    public string? Nome { get; set; } = null!;

    [Required(ErrorMessage = "Descrição do produto está vazio.")]
    public string? Descricao { get; set; } = null!;

    [Required(ErrorMessage = "Preço do produto está vazio.")]
    [DecimalStringValidation(ErrorMessage = "Por favor, insira um número decimal válido.")]
    [Range(0.01, 9999999999999999.99, ErrorMessage = "O preço deve estar entre 0.01 e 9999999999999999.99.")]
    public decimal Preco { get; set; }

    [Required(ErrorMessage = "Unidade de medida do produto está vazio.")]
    public string? UnidadeMedida { get; set; }

    [Required(ErrorMessage = "Imagem do produto está vazio.")]
    public string? ImageUrl { get; set; }

    [Required(ErrorMessage = "Código de barras do produto está vazio.")]
    [CodigoDeBarrasProduto(ErrorMessage = "Código de barras inválido.")]
    public string? CodigoBarras { get; set; }

    [Required(ErrorMessage = "Estoque alvo do produto está vazio.")]
    [Range(0, 999, ErrorMessage = "O número deve estar entre 0 e 999.")]
    public int EstoqueAlvo { get; set; }

    public bool IsAtivo { get; set; }
  }

  public record ProdutoResponseModel
  {
    public string Id { get; set; }

    public ProdutoResponseModel(string id)
    {
      Id = id;
    }
  }
}
