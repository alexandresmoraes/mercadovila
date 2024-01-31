class RealizarPagamentoModel {
  late String userId;
  late num tipoPagamento;
  late List<num> vendasId;

  RealizarPagamentoModel({
    required this.userId,
    required this.tipoPagamento,
    required this.vendasId,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['tipoPagamento'] = tipoPagamento;
    data['vendasId'] = vendasId;
    return data;
  }
}

class RealizarPagamentoResponseModel {
  RealizarPagamentoResponseModel({required this.id});
  late final num id;

  RealizarPagamentoResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
