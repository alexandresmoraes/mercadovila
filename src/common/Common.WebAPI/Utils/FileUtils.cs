using Microsoft.AspNetCore.Http;

namespace Common.WebAPI.Utils
{
  public interface IFileUtils
  {
    Task<string> SaveFile(IFormFile file, string path);
  }

  public class FileUtils : IFileUtils
  {
    public async Task<string> SaveFile(IFormFile file, string path)
    {
      var userImagePath = path;
      var currentDirectory = Directory.GetCurrentDirectory();
      var filename = Guid.NewGuid().ToString() + Path.GetExtension(file!.FileName);
      var fullFilename = Path.Combine(currentDirectory, userImagePath, filename);
      var directory = Path.GetDirectoryName(fullFilename)!;

      if (!Directory.Exists(directory))
      {
        Directory.CreateDirectory(directory);
      }

      using (var stream = new FileStream(fullFilename, FileMode.Create))
      {
        await file.CopyToAsync(stream);
      }

      return filename;
    }
  }
}
