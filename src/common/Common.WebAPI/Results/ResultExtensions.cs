using Microsoft.Extensions.DependencyInjection;

namespace Common.WebAPI.Results
{
  public static class ResultExtensions
  {
    public static IServiceCollection AddResultFilter(this IServiceCollection services)
    {
      services.AddMvc(opt =>
      {
        opt.Filters.Add<ResultBadRequestFilterAttribute>();
        opt.Filters.Add<ResultCreatedFilterAttribute>();
        opt.Filters.Add<ResultNotFoundFilterAttribute>();
        opt.Filters.Add<ResultUnauthorizedFilterAttribute>();
        opt.Filters.Add<ResultForbiddenFilterAttribute>();
        opt.Filters.Add<ResultNoContentFilterAttribute>();
        opt.Filters.Add<ResultOkFilterAttribute>();
        opt.Filters.Add<ValidationFilterAttribute>();
      });

      return services;
    }
  }
}