using Common.WebAPI.Validation;
using System.ComponentModel.DataAnnotations;

namespace Auth.API.Models
{
  public record PhotoUploadModel
  {
    [Required(ErrorMessage = "Please select a file.")]
    [DataType(DataType.Upload)]
    [MaxFileSize(5 * 1024 * 1024)]
    [AllowedExtensions(new string[] { ".jpg", ".png" })]
    public IFormFile File { get; set; }

    public PhotoUploadModel(IFormFile file)
    {
      File = file;
    }
  }
}