﻿using System.Text.Json;

namespace Catalogo.API.Data.Dto
{
  public record ProdutoDto
  {
    public string Id { get; set; } = null!;
    public string Nome { get; set; } = null!;
    public string Descricao { get; set; } = null!;
    public string ImageUrl { get; set; } = null!;
    public decimal Preco { get; set; }
    public string UnidadeMedida { get; set; } = null!;
    public string CodigoBarras { get; set; } = null!;
    public int EstoqueAlvo { get; set; }
    public int Estoque { get; set; }
    public double Rating { get; set; }
    public int RatingCount { get; set; }
    public bool IsAtivo { get; set; }

    public override string ToString()
    {
      return JsonSerializer.Serialize(this);
    }
  }
}