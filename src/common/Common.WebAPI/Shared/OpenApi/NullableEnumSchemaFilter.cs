using Common.WebAPI.Utils;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Reflection;

namespace Common.WebAPI.Shared.OpenApi
{
  public class NullableEnumSchemaFilter : ISchemaFilter
  {
    public void Apply(OpenApiSchema schema, SchemaFilterContext context)
    {
      var isReferenceType =
          TypeUtils.IsReference(context.Type) &&
          !TypeUtils.IsCLR(context.Type) &&
          !TypeUtils.IsMicrosoft(context.Type);
      if (!isReferenceType) { return; }

      var bindingFlags = BindingFlags.Public | BindingFlags.Instance;
      var members = context.Type.GetFields(bindingFlags).Cast<MemberInfo>()
          .Concat(context.Type.GetProperties(bindingFlags))
          .ToArray();
      var hasNullableEnumMembers = members.Any(x => TypeUtils.IsNullableEnum(x.GetMemberType()));
      if (!hasNullableEnumMembers) { return; }

      schema.Properties.Where(x => !x.Value.Nullable).ToList().ForEach(property =>
      {
        var name = property.Key;
        var possibleNames = new string[]
        {
          name,
          TextCaseUtils.ToPascalCase(name),
        };
        var sourceMember = possibleNames
            .Select(n => context.Type.GetMember(n, bindingFlags).FirstOrDefault())
            .Where(x => x != null)
            .FirstOrDefault();
        if (sourceMember == null) { return; }

        var sourceMemberType = sourceMember.GetMemberType();
        if (sourceMemberType == null || !TypeUtils.IsNullableEnum(sourceMemberType)) { return; }

        if (property.Value.Reference != null)
        {
          property.Value.Nullable = true;
          property.Value.AllOf = new List<OpenApiSchema>()
          {
            new OpenApiSchema
            {
              Reference = property.Value.Reference,
            },
          };
          property.Value.Reference = null;
        }
      });
    }
  }
}
