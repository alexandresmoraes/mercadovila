class ProdutoModel {
  ProdutoModel({
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.unidadeMedida,
    required this.codigoBarras,
    required this.estoqueAlvo,
    required this.estoque,
    required this.isAtivo,
  });
  String? id;
  late final String nome;
  late final String descricao;
  late final String preco;
  late final String unidadeMedida;
  late final String codigoBarras;
  late final int estoqueAlvo;
  late final int estoque;
  late final bool isAtivo;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nome'] = nome;
    data['descricao'] = descricao;
    data['preco'] = preco;
    data['unidadeMedida'] = unidadeMedida;
    data['codigoBarras'] = codigoBarras;
    data['estoqueAlvo'] = estoqueAlvo;
    data['estoque'] = estoque;
    data['isAtivo'] = isAtivo;
    return data;
  }

  ProdutoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    preco = json['preco'];
    unidadeMedida = json['unidadeMedida'];
    codigoBarras = json['codigoBarras'];
    estoqueAlvo = json['estoqueAlvo'];
    estoque = json['estoque'];
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
