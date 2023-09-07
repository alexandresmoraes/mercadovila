using Microsoft.Extensions.DependencyInjection;

namespace Common.WebAPI.Utils
{
  public static class UtilsExtensions
  {
    public static IServiceCollection AddUtils(this IServiceCollection services)
    {
      services.AddScoped<IFileUtils, FileUtils>();
      services.AddScoped<IValidateUtils, ValidateUtils>();

      return services;
    }
  }
}
