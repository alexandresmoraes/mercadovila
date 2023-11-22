
using Microsoft.Extensions.Configuration;

namespace Common.WebAPI.Utils
{
  public static class ConfigurationExtensions
  {
    public static TSettings BindSettings<TSettings>(this IConfiguration configuration, string sectionKey)
      where TSettings : new()
    {
      var settings = new TSettings();
      configuration.GetSection(sectionKey).Bind(settings);
      return settings;
    }
  }
}