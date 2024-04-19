using System.ComponentModel.DataAnnotations;

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

      return Ean13IsValid(codigoDeBarras) || Ean8Isvalid(codigoDeBarras);
    }

    private bool Ean8Isvalid(string codigoDeBarras)
    {
      if (codigoDeBarras.Length != 8)
        return false;

      var ean8 = codigoDeBarras;

      int somaPares = 0;
      int somaImpares = 0;

      for (int i = 0; i < 7; i += 2)
      {
        somaPares += int.Parse(ean8[i].ToString());
      }

      for (int i = 1; i < 7; i += 2)
      {
        somaImpares += int.Parse(ean8[i].ToString());
      }

      int somaTotal = (somaPares * 3) + somaImpares;

      int digitoVerificadorCalculado = 10 - (somaTotal % 10);

      if (digitoVerificadorCalculado == 10)
      {
        digitoVerificadorCalculado = 0;
      }

      int digitoVerificador = int.Parse(ean8[7].ToString());

      return digitoVerificador == digitoVerificadorCalculado;
    }

    private bool Ean13IsValid(string codigoDeBarras)
    {
      if (codigoDeBarras.Length != 13)
        return false;

      var ean13 = codigoDeBarras;

      var pares = ean13.Take(codigoDeBarras.Length - 1).Where((c, i) => i % 2 == 0).Select(c => int.Parse(c.ToString()));
      var impares = ean13.Take(codigoDeBarras.Length - 1).Where((c, i) => i % 2 != 0).Select(c => int.Parse(c.ToString()));

      int somaPares = pares.Sum();
      int somaImpares = impares.Sum();

      somaImpares *= 3;

      int somaTotal = somaPares + somaImpares;

      int proximoMultiploDe10 = (int)Math.Ceiling(somaTotal / 10.0) * 10;

      int digitoVerificador = proximoMultiploDe10 - somaTotal;

      int digitoVerificadorReal = int.Parse(ean13[12].ToString());

      return digitoVerificadorReal == digitoVerificador;
    }
  }
}