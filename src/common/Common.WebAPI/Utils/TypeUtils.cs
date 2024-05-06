using System.Reflection;

namespace Common.WebAPI.Utils
{
  public static class TypeUtils
  {
    public static bool IsCLR(Type type) => type.Assembly == typeof(int).Assembly;

    public static bool IsMicrosoft(Type type) => type.Assembly.FullName?.StartsWith("Microsoft") ?? false;

    public static bool IsValue(Type type) => type.IsValueType;

    public static bool IsReference(Type type) => !type.IsValueType && type.IsClass;

    public static bool IsNullableReferenceProperty(PropertyInfo property) =>
        new NullabilityInfoContext().Create(property).WriteState is NullabilityState.Nullable;

    public static bool IsEnum(Type type) => type.IsEnum || (Nullable.GetUnderlyingType(type)?.IsEnum ?? false);

    public static bool IsNullableEnum(Type type) => Nullable.GetUnderlyingType(type)?.IsEnum ?? false;

    public static bool IsNotNullableEnum(Type type) => IsEnum(type) && !IsNullableEnum(type);
  }
}
