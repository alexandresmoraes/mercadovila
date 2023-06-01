using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace Common.WebAPI.Validation
{
  public class MaxFileSizeAttribute : ValidationAttribute
  {
    private readonly int _maxFileSize;
    public MaxFileSizeAttribute(int maxFileSize)
    {
      _maxFileSize = maxFileSize;
    }

    protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
    {
      var file = value as IFormFile;

      if (file is null)
      {
        return new ValidationResult("File is null.");
      }
      else
      {
        if (file.Length > _maxFileSize)
        {
          return new ValidationResult($"Maximum allowed file size is {_maxFileSize} bytes.");
        }

        return ValidationResult.Success!;
      }
    }
  }
}