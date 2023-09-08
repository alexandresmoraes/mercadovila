using System.ComponentModel.DataAnnotations;

namespace Catalogo.API.Models
{
  public class NotificacaoModel
  {
    [Required(ErrorMessage = "Título da notificação está vazio.")]
    public string Titulo { get; set; } = null!;

    [Required(ErrorMessage = "Mensagem da notificação está vazio.")]
    public string Mensagem { get; set; } = null!;

    public string? ImageUrl { get; set; }    
  }

  public record NotificacaoResponseModel
  {
    public string Id { get; set; }

    public NotificacaoResponseModel(string id)
    {
      Id = id;
    }
  }
}