using Common.WebAPI.Auth;
using Common.WebAPI.Results;
using MediatR;
using Vendas.API.Application.Responses;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Commands
{
  public class CriarVendaCommandHandler
    : IRequestHandler<CriarVendaCommand, Result<CriarVendaCommandResponse>>
  {
    private readonly ICompradorRepository _compradorRepository;
    private readonly IVendaRepository _vendaRepository;
    private readonly IAuthService _authService;

    public CriarVendaCommandHandler(ICompradorRepository compradorRepository, IVendaRepository vendaRepository, IAuthService authService)
    {
      _compradorRepository = compradorRepository;
      _vendaRepository = vendaRepository;
      _authService = authService;
    }

    public async Task<Result<CriarVendaCommandResponse>> Handle(CriarVendaCommand request, CancellationToken cancellationToken)
    {
      var userId = _authService.GetUserId();

      var comprador = await _compradorRepository.GetAsync(userId) ?? new Comprador(userId, request.CompradorNome);

      var venda = new Venda(
        comprador: comprador,
        vendaItens: GerarVendaItensAleatorios(5),
        status: EnumVendaStatus.PendentePagamento
      );

      await _vendaRepository.AddAsync(venda);

      return Result.Ok(new CriarVendaCommandResponse
      {
        Id = venda.Id,
      });
    }

    public List<VendaItem> GerarVendaItensAleatorios(int quantidade)
    {
      List<VendaItem> vendaItens = new List<VendaItem>();
      Random random = new Random();

      string[] nomes = { "Produto A", "Produto B", "Produto C", "Produto D", "Produto E" };
      string[] descricoes = { "Descrição A", "Descrição B", "Descrição C", "Descrição D", "Descrição E" };
      string[] unidadesDeMedida = { "kg", "un", "m", "g", "L" };

      for (int i = 0; i < quantidade; i++)
      {
        string nomeAleatorio = nomes[random.Next(nomes.Length)];
        string descricaoAleatoria = descricoes[random.Next(descricoes.Length)];
        decimal precoAleatorio = (decimal)random.NextDouble() * 100;
        int quantidadeAleatoria = random.Next(1, 100);
        string unidadeMedidaAleatoria = unidadesDeMedida[random.Next(unidadesDeMedida.Length)];
        string imageUrlAleatoria = $"https://example.com/{nomeAleatorio.Replace(" ", "-").ToLower()}.jpg";

        VendaItem vendaItem = new VendaItem(nomeAleatorio, imageUrlAleatoria, descricaoAleatoria, precoAleatorio, quantidadeAleatoria, unidadeMedidaAleatoria);
        vendaItens.Add(vendaItem);
      }

      return vendaItens;
    }
  }
}