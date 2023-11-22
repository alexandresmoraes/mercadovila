using System.Text.Json;

namespace Catalogo.API.Data.Dto
{
  public record NotificacaoDto
  {
    public string Id { get; set; } = null!;

    public string Titulo { get; set; } = null!;

    public string Mensagem { get; set; } = null!;

    public string? ImageUrl { get; set; }

    public DateTime DataCriacao { get; set; } = DateTime.Now;

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}