using Compras.API.Application.Commands;
using FluentValidation;

namespace Compras.API.Application.Validators
{
  public class CriarCompraCommandValidator : AbstractValidator<CriarCompraCommand>
  {
    public CriarCompraCommandValidator()
    {
      RuleFor(c => c.UsuarioNome)
        .NotEmpty().WithMessage("O nome do comprador é obrigatório");

      RuleFor(x => x.CompraItens)
        .NotNull().WithMessage("A lista de itens não pode ser nula.")
        .NotEmpty().WithMessage("A lista de itens não pode estar vazia.")
        .ForEach(item =>
        {
          item.SetValidator(new CriarComparItemCommandValidator());
        });
    }
  }

  public class CriarComparItemCommandValidator : AbstractValidator<CriarComparItemCommand>
  {
    public CriarComparItemCommandValidator()
    {
      RuleFor(c => c.ProdutoId).NotEmpty().WithMessage("O id do produto é obrigatório");

      RuleFor(c => c.Nome).NotEmpty().WithMessage("O nome do produto é obrigatório");

      RuleFor(c => c.ImageUrl).NotEmpty().WithMessage("A imagem do produto é obrigatório");

      RuleFor(c => c.Descricao).NotEmpty().WithMessage("O descrição do comprador é obrigatório");

      RuleFor(c => c.PrecoPago)
        .NotEmpty().WithMessage("O preço pago do produto é obrigatório")
        .GreaterThan(0).WithMessage("O preço pago do produto deve ser menor ou igual a zero");

      RuleFor(c => c.PrecoSugerido)
        .NotEmpty().When(c => !c.IsPrecoMedioSugerido)
        .WithMessage("O preço sugerido é obrigatório quando IsPrecoSugerido = true.")
        .GreaterThan(0).When(c => !c.IsPrecoMedioSugerido)
        .WithMessage("O preço sugerido é obrigatório quando IsPrecoSugerido = true.");

      RuleFor(c => c.Quantidade)
        .NotNull().WithMessage("A quantidade do produto é obrigatório")
        .GreaterThan(0).WithMessage("A quantidade do produto é obrigatório");

      RuleFor(c => c.UnidadeMedida).NotEmpty().WithMessage("A unidade de medida do produto é obrigatório");
    }
  }
}
