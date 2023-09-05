using System.ComponentModel.DataAnnotations;

namespace Common.WebAPI.Validation
{
  public class DecimalStringValidationAttribute : ValidationAttribute
  {
    public override bool IsValid(object? value)
    {
      if (value is null)
      {
        return true;
      }

      string stringValue = value.ToString()!;

      if (decimal.TryParse(stringValue, out decimal result))
      {
        return true;
      }

      return false;
    }
  }
}