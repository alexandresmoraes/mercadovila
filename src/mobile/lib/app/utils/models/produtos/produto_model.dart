class ProdutoModel {
  ProdutoModel({
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.preco,
    required this.unidadeMedida,
    required this.codigoBarras,
    required this.estoqueAlvo,
    required this.isAtivo,
  });
  String? id;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final double preco;
  late final String unidadeMedida;
  late final String codigoBarras;
  late final int estoqueAlvo;
  late final bool isAtivo;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nome'] = nome;
    data['descricao'] = descricao;
    data['imageUrl'] = imageUrl;
    data['preco'] = preco;
    data['unidadeMedida'] = unidadeMedida;
    data['codigoBarras'] = codigoBarras;
    data['estoqueAlvo'] = estoqueAlvo;
    data['isAtivo'] = isAtivo;
    return data;
  }

  ProdutoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    imageUrl = json['imageUrl'];
    preco = json['preco'];
    unidadeMedida = json['unidadeMedida'];
    codigoBarras = json['codigoBarras'];
    estoqueAlvo = json['estoqueAlvo'];
    isAtivo = json['isAtivo'];
  }
}

class ProdutoResponseModel {
  ProdutoResponseModel({required this.id});
  late final String id;

  ProdutoResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
