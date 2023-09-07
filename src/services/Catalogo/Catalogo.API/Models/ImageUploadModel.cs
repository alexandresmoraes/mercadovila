using Common.WebAPI.Validation;
using System.ComponentModel.DataAnnotations;

namespace Catalogo.API.Models
{
  public record ImageUploadModel
  {
    [Required(ErrorMessage = "File não pode ser vazio.")]
    [DataType(DataType.Upload)]
    [MaxFileSize(5 * 1024 * 1024)]
    [AllowedExtensions(new string[] { ".jpg", ".png" })]
    public IFormFile? File { get; set; }

    public ImageUploadModel(IFormFile? file)
    {
      File = file;
    }
  }

  public record ImageUploadResponseModel
  {
    public string Filename { get; set; }

    public ImageUploadResponseModel(string filename)
    {
      Filename = filename;
    }
  }
}
