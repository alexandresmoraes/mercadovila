using FluentValidation;
using Vendas.API.Application.Commands;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Validators
{
  public sealed class CriarVendaCommandValidator : AbstractValidator<CriarVendaCommand>
  {
    public CriarVendaCommandValidator()
    {
      RuleFor(c => c.CompradorNome).NotEmpty().WithMessage("O nome do comprador é obrigatório.");

      RuleFor(c => c.TipoPagamento)
        .Cascade(CascadeMode.Stop)
        .NotNull().WithMessage("O tipo pagamento não pode ser nulo.");

      RuleFor(c => c.TipoPagamento)
        .Must(c => c is null || Enum.IsDefined(typeof(EnumTipoPagamento), c.Value))
        .WithMessage("O valor fornecido não é válido para a enumeração tipo pagamento.");
    }
  }
}
