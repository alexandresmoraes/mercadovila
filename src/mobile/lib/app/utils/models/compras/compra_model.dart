class CompraItemModel {
  String produtoId;
  String nome;
  String imageUrl;
  String descricao;
  int estoqueAtual;
  double precoPago;
  double precoSugerido;
  bool isPrecoMedioSugerido;
  int quantidade;
  String unidadeMedida;

  CompraItemModel({
    required this.produtoId,
    required this.nome,
    required this.imageUrl,
    required this.descricao,
    required this.estoqueAtual,
    required this.precoPago,
    required this.precoSugerido,
    required this.isPrecoMedioSugerido,
    required this.quantidade,
    required this.unidadeMedida,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['produtoId'] = produtoId;
    data['nome'] = nome;
    data['imageUrl'] = imageUrl;
    data['descricao'] = descricao;
    data['estoqueAtual'] = estoqueAtual;
    data['precoPago'] = precoPago;
    data['precoSugerido'] = precoSugerido;
    data['isPrecoMedioSugerido'] = isPrecoMedioSugerido;
    data['quantidade'] = quantidade;
    data['unidadeMedida'] = unidadeMedida;
    return data;
  }
}

class CompraModel {
  String usuarioNome;
  String? usuarioFotoUrl;
  List<CompraItemModel> compraItens;

  CompraModel({
    required this.usuarioNome,
    this.usuarioFotoUrl,
    required this.compraItens,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['usuarioNome'] = usuarioNome;
    data['usuarioFotoUrl'] = usuarioFotoUrl;
    data['compraItens'] = compraItens.map((v) => v.toJson()).toList();
    return data;
  }
}

class CompraResponseModel {
  late final int id;

  CompraResponseModel({required this.id});

  CompraResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
