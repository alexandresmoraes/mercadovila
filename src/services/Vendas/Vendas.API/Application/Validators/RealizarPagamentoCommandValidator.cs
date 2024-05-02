using FluentValidation;
using Vendas.API.Application.Commands;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Validators
{
  public class RealizarPagamentoCommandValidator : AbstractValidator<RealizarPagamentoCommand>
  {
    public RealizarPagamentoCommandValidator()
    {
      RuleFor(c => c.UserId).NotEmpty().WithMessage("O id do comprador é obrigatório");

      RuleFor(c => c.TipoPagamento)
        .Cascade(CascadeMode.Stop)
        .NotNull().WithMessage("O tipo pagamento não pode ser nulo.");

      RuleFor(c => c.TipoPagamento)
        .Must(c => c == null || Enum.IsDefined(typeof(EnumTipoPagamento), c.Value))
        .WithMessage("O valor fornecido não é válido para a enumeração tipo pagamento.");

      RuleFor(c => c.MesReferencia)
       .Cascade(CascadeMode.Stop)
       .NotNull().WithMessage("O mês de refêrencia não pode ser nulo.");

      RuleFor(c => c.TipoPagamento)
        .Must(c => c == null || Enum.IsDefined(typeof(EnumMesReferencia), c.Value))
        .WithMessage("O valor fornecido não é válido para a enumeração tipo pagamento.");

      RuleFor(c => c.VendasId)
        .NotNull().WithMessage("A lista de id de vendas não pode ser nula.")
        .NotEmpty().WithMessage("A lista de id de vendas não pode estar vazia.");
    }
  }
}
