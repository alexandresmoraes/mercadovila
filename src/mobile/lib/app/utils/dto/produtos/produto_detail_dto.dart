class ProdutoDetailDto {
  ProdutoDetailDto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.preco,
    required this.unidadeMedida,
    required this.estoque,
    required this.rating,
    required this.ratingCount,
    required this.isAtivo,
    required this.isFavorito,
  });
  late final String id;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final double preco;
  late final String unidadeMedida;
  late final int estoque;
  late final num rating;
  late final int ratingCount;
  late final bool isAtivo;
  late final bool isFavorito;

  ProdutoDetailDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    imageUrl = json['imageUrl'];
    preco = json['preco'];
    unidadeMedida = json['unidadeMedida'];
    estoque = json['estoque'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    isAtivo = json['isAtivo'];
    isFavorito = json['isFavorito'];
  }

  String getDisponiveis() => estoque == 0
      ? 'Fora de estoque'
      : estoque == 1
          ? '1 disponível'
          : '$estoque disponíveis';
}
