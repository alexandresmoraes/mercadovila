﻿using Common.WebAPI.Validation;
using System.ComponentModel.DataAnnotations;

namespace Auth.API.Models
{
  public record PhotoUploadModel
  {
    [Required(ErrorMessage = "File não pode ser vazio.")]
    [DataType(DataType.Upload)]
    [MaxFileSize(5 * 1024 * 1024)]
    [AllowedExtensions(new string[] { ".jpg", ".png" })]
    public IFormFile? File { get; set; }

    public PhotoUploadModel(IFormFile? file)
    {
      File = file;
    }
  }

  public record PhotoUploadResponseModel
  {
    public string Filename { get; set; }

    public PhotoUploadResponseModel(string filename)
    {
      Filename = filename;
    }
  }
}