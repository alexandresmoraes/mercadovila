class ProdutoDto {
  ProdutoDto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.preco,
    required this.unidadeMedida,
    required this.codigoBarras,
    required this.estoqueAlvo,
    required this.estoque,
    required this.rating,
    required this.ratingCount,
    required this.isAtivo,
  });
  late final String id;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final num preco;
  late final String unidadeMedida;
  late final String codigoBarras;
  late final int estoqueAlvo;
  late final int estoque;
  late final num rating;
  late final int ratingCount;
  late final bool isAtivo;

  ProdutoDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    imageUrl = json['imageUrl'];
    preco = json['preco'];
    unidadeMedida = json['unidadeMedida'];
    codigoBarras = json['codigoBarras'];
    estoqueAlvo = json['estoqueAlvo'];
    estoque = json['estoque'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    isAtivo = json['isAtivo'];
  }
}
