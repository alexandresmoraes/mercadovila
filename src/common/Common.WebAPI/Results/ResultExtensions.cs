using Microsoft.Extensions.DependencyInjection;

namespace Common.WebAPI.Results
{
  public static class ResultExtensions
  {
    public static IServiceCollection AddResultFilter(this IServiceCollection services)
    {
      services.AddMvc(opt =>
      {
        opt.Filters.Add<ResultFilterAttribute>();
      });

      return services;
    }
  }
}