class ListaComprasDto {
  ListaComprasDto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.unidadeMedida,
    required this.estoqueAlvo,
    required this.estoque,
    required this.rating,
    required this.ratingCount,
  });
  late final String id;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final String unidadeMedida;
  late final int estoqueAlvo;
  late final int estoque;
  late final num rating;
  late final int ratingCount;

  ListaComprasDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    imageUrl = json['imageUrl'];
    unidadeMedida = json['unidadeMedida'];
    estoqueAlvo = json['estoqueAlvo'];
    estoque = json['estoque'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
  }
}
