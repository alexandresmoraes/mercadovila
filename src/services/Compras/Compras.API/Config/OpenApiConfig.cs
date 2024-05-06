using Common.WebAPI.Shared.OpenApi;
using Microsoft.OpenApi.Any;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace Compras.API.Config
{
  public static class OpenApiConfig
  {
    public static IServiceCollection AddOpenApi(this IServiceCollection services)
    {
      services.AddSwaggerGen(c =>
      {
        c.SwaggerDoc("v1", new OpenApiInfo()
        {
          Title = "Vila Sesmo Compras API",
          Description = "API de controle de compras do Vila Sesmo.",
          Contact = new OpenApiContact() { Name = "Alexandre de Moraes", Email = "alexandresmoraes@me.com" },
          License = new OpenApiLicense() { Name = "MIT", Url = new Uri("https://opensource.org/Licenses/MIT") }
        });

        c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
        {
          Description = "Insira o token JWT desta maneira: Bearer {seu token}",
          Name = "Authorization",
          Scheme = "Bearer",
          BearerFormat = "JWT",
          In = ParameterLocation.Header,
          Type = SecuritySchemeType.ApiKey
        });

        c.AddSecurityRequirement(new OpenApiSecurityRequirement
        {
          {
            new OpenApiSecurityScheme
            {
              Reference = new OpenApiReference
              {
                Type = ReferenceType.SecurityScheme,
                Id = "Bearer"
              }
            },
            new string[] {}
          }
        });

        var xmlPath = Path.Combine(AppContext.BaseDirectory, "Compras.API.xml");
        c.IncludeXmlComments(xmlPath, true);

        c.SchemaFilter<EnumDescriptionSchemaFilter>();
        c.SchemaFilter<NullableEnumSchemaFilter>();
      });

      return services;
    }

    public static IApplicationBuilder UseOpenApi(this IApplicationBuilder app)
    {
      app.UseSwagger();
      app.UseSwaggerUI(c =>
      {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "v1");
        c.DefaultModelsExpandDepth(-1);
      });

      return app;
    }
  }

  public class EnumDescriptionSchemaFilter : ISchemaFilter
  {
    public void Apply(OpenApiSchema schema, SchemaFilterContext context)
    {
      if (context.Type.IsEnum)
      {
        var enumStringNames = Enum.GetNames(context.Type);
        IEnumerable<long> enumStringValues;
        try
        {
          enumStringValues = Enum.GetValues(context.Type).Cast<long>();
        }
        catch
        {
          enumStringValues = Enum.GetValues(context.Type).Cast<int>().Select(i => Convert.ToInt64(i));
        }
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
