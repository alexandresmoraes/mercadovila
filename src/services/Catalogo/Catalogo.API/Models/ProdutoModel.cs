using Common.WebAPI.Validation;
using System.ComponentModel.DataAnnotations;

namespace Catalogo.API.Models
{
  public record ProdutoModel
  {
    public string? Id { get; set; }

    [Required(ErrorMessage = "Nome do produto está vazio.")]
    public string? Nome { get; set; } = null!;

    [Required(ErrorMessage = "Descrição do produto está vazio.")]
    public string? Descricao { get; set; } = null!;

    [RegularExpression(@"^\d+(\.\d{1,2})?$")]
    [Range(0, 9999999999999999.99)]
    public decimal Preco { get; set; }

    [Required(ErrorMessage = "Unidade de medida do produto está vazio.")]
    public string? UnidadeMedida { get; set; }

    [Required(ErrorMessage = "Código de barras do produto está vazio.")]
    [CodigoDeBarrasProduto(ErrorMessage = "Código de barras inválido.")]
    public string? CodigoBarras { get; set; }

    [Required(ErrorMessage = "Estoque alvo do produto está vazio.")]
    [Range(0, 999, ErrorMessage = "O número deve estar entre 0 e 999.")]
    public int EstoqueAlvo { get; set; }

    [Required(ErrorMessage = "Estoque do produto está vazio.")]
    [Range(0, 999, ErrorMessage = "O número deve estar entre 0 e 999.")]
    public int Estoque { get; set; }
    public bool IsAtivo { get; set; }
  }

  public record ProdutoResponseModel
  {
    public string Id { get; private set; }

    public ProdutoResponseModel(string id)
    {
      Id = id;
    }
  }
}