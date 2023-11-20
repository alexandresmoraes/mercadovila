using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace Common.WebAPI.Validation
{
  [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
  public class CodigoDeBarrasProdutoAttribute : ValidationAttribute
  {
    public override bool IsValid(object? value)
    {
      if (value is null || string.IsNullOrWhiteSpace(value.ToString()))
      {
        return true;
      }

      string codigoDeBarras = value.ToString()!;

      if (!Regex.IsMatch(codigoDeBarras, @"^\d{13}$"))
      {
        return false;
      }

      var pares = codigoDeBarras.Take(codigoDeBarras.Length - 1).Where((c, i) => i % 2 == 0).Select(c => int.Parse(c.ToString()));
      var impares = codigoDeBarras.Take(codigoDeBarras.Length - 1).Where((c, i) => i % 2 != 0).Select(c => int.Parse(c.ToString()));

      int somaPares = pares.Sum();
      int somaImpares = impares.Sum();

      somaImpares *= 3;

      int somaTotal = somaPares + somaImpares;

      int proximoMultiploDe10 = (int)Math.Ceiling(somaTotal / 10.0) * 10;

      int digitoVerificador = proximoMultiploDe10 - somaTotal;

      int digitoVerificadorReal = int.Parse(codigoDeBarras[12].ToString());

      return digitoVerificadorReal == digitoVerificador;
    }
  }
}