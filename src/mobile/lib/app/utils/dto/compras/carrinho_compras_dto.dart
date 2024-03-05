class CarrinhoComprasItemDto {
  CarrinhoComprasItemDto({
    required this.produtoId,
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.unidadeMedida,
    required this.codigoBarras,
    required this.preco,
    required this.estoque,
    required this.rating,
    required this.ratingCount,
    required this.isAtivo,
    required this.precoPago,
    required this.precoSugerido,
    required this.quantidade,
    required this.isPrecoMedioSugerido,
  });
  late final String produtoId;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final String unidadeMedida;
  late final String codigoBarras;
  late final double preco;
  late final int estoque;
  late final int rating;
  late final int ratingCount;
  late final bool isAtivo;
  late double precoPago;
  late double precoSugerido;
  late int quantidade;
  late bool isPrecoMedioSugerido;

  bool isDisponivel() => isAtivo && estoque > 0;

  String getDisponiveis() => !isDisponivel()
      ? 'Indisponível'
      : estoque == 1
          ? '1 disponível'
          : '$estoque disponíveis';

  double getPrecoSugerido() {
    if (isPrecoMedioSugerido) {
      precoSugerido = ((preco * estoque) + (precoPago * quantidade)) / (quantidade + estoque);
    }

    return precoSugerido;
  }
}
