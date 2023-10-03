using Common.WebAPI.Results;
using MediatR;
using System.Text.Json.Serialization;
using Vendas.API.Application.Responses;

namespace Vendas.API.Application.Commands
{
  public record CriarVendaCommand : IRequest<Result<CriarVendaCommandResponse>>
  {
    [JsonIgnore]
    public string? UserId { get; set; }
    public string CompradorNome { get; set; } = null!;
  }
}