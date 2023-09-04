class ProdutoDto {
  ProdutoDto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.estoqueAlvo,
    required this.estoque,
    required this.rating,
    required this.ratingCount,
    required this.isAtivo,
  });
  late final String id;
  late final String nome;
  late final String descricao;
  late final double preco;
  late final int estoqueAlvo;
  late final int estoque;
  late final double rating;
  late final int ratingCount;
  late final bool isAtivo;

  ProdutoDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    preco = json['preco'];
    estoqueAlvo = json['estoqueAlvo'];
    estoque = json['estoque'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    isAtivo = json['isAtivo'];
  }
}
