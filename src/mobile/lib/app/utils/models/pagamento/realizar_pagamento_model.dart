class RealizarPagamentoModel {
  late String userId;
  late num tipoPagamento;
  late List<int> vendasId;

  RealizarPagamentoModel({
    required this.userId,
    required this.tipoPagamento,
    this.vendasId = const [],
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['tipoPagamento'] = tipoPagamento;
    data['vendasId'] = vendasId;
    return data;
  }
}
