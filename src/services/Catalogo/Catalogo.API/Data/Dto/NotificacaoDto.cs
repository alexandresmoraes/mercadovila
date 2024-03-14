using System.Text.Json;

namespace Catalogo.API.Data.Dto
{
  public record NotificacaoDto
  {
    public string Id { get; set; } = null!;

    public string Titulo { get; set; } = null!;

    public string Mensagem { get; set; } = null!;

    public string? ImageUrl { get; set; }

    public DateTimeOffset DataCriacao { get; set; } = DateTimeOffset.UtcNow;

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}