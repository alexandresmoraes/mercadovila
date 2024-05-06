using Microsoft.OpenApi.Any;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace Common.WebAPI.Shared.OpenApi
{
  public class EnumDescriptionSchemaFilter : ISchemaFilter
  {
    public void Apply(OpenApiSchema schema, SchemaFilterContext context)
    {
      if (context.Type.IsEnum)
      {
        var enumStringNames = Enum.GetNames(context.Type);
        IEnumerable<long> enumStringValues;
        enumStringValues = Enum.GetValues(context.Type).Cast<int>().Select(i => Convert.ToInt64(i));
        var enumStringKeyValuePairs = enumStringNames.Zip(enumStringValues, (name, value) => $"{value} = {name}");
        var enumStringNamesAsOpenApiArray = new OpenApiArray();
        enumStringNamesAsOpenApiArray.AddRange(enumStringNames.Select(name => new OpenApiString(name)).ToArray());
        schema.Description = string.Join("\n", enumStringKeyValuePairs);
        schema.Extensions.Add("x-enum-varnames", enumStringNamesAsOpenApiArray);
        schema.Extensions.Add("x-enumNames", enumStringNamesAsOpenApiArray);
      }
    }
  }
}