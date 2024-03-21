class VendaModel {
  VendaModel({
    required this.compradorNome,
    this.compradorFotoUrl,
    required this.tipoPagamento,
  });
  late final String compradorNome;
  late final String? compradorFotoUrl;
  late final int tipoPagamento;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['compradorNome'] = compradorNome;
    data['compradorFotoUrl'] = compradorFotoUrl;
    data['tipoPagamento'] = tipoPagamento;
    return data;
  }
}

class VendaResponseModel {
  VendaResponseModel({required this.id});
  late final int id;

  VendaResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
