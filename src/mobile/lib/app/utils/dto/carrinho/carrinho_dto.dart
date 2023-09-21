class CarrinhoDto {
  CarrinhoDto({
    required this.itens,
    required this.subtotal,
    required this.total,
  });

  late final double subtotal;
  late final double total;
  late final List<CarrinhoItemDto> itens;

  CarrinhoDto.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    total = json['total'];
    itens = List<CarrinhoItemDto>.from(json["itens"].map((_) => CarrinhoItemDto.fromJson(_)));
  }
}

class CarrinhoItemDto {
  CarrinhoItemDto({
    required this.produtoId,
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
    required this.quantidade,
  });
  late final String produtoId;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final double preco;
  late final String unidadeMedida;
  late final int estoque;
  late final int rating;
  late final int ratingCount;
  late final bool isAtivo;
  late final bool isFavorito;
  late final int quantidade;

  CarrinhoItemDto.fromJson(Map<String, dynamic> json) {
    produtoId = json['produtoId'];
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
    quantidade = json['quantidade'];
  }

  String getDisponiveis() => estoque == 0
      ? 'Fora de estoque'
      : estoque == 1
          ? '1 disponível'
          : '$estoque disponíveis';
}
