class PagamentoDetalheDto {
  PagamentoDetalheDto({
    required this.compradorUserId,
    required this.total,
  });
  late final String compradorUserId;
  late final String? compradorNome;
  late final String? compradorFotoUrl;
  late final num total;
  late final List<PagamentoDetalheVendaDto> vendas;

  PagamentoDetalheDto.fromJson(Map<String, dynamic> json) {
    compradorUserId = json['compradorUserId'];
    compradorNome = json['compradorNome'];
    compradorFotoUrl = json['compradorFotoUrl'];
    total = json['total'];
    vendas = List<PagamentoDetalheVendaDto>.from(json["vendas"].map((x) => PagamentoDetalheVendaDto.fromJson(x)));
  }
}

class PagamentoDetalheVendaDto {
  PagamentoDetalheVendaDto({
    required this.vendaId,
    required this.status,
    required this.dataHora,
    required this.total,
  });
  late final num vendaId;
  late final int status;
  late final DateTime dataHora;
  late final num total;

  PagamentoDetalheVendaDto.fromJson(Map<String, dynamic> json) {
    vendaId = json['vendaId'];
    status = json['status'];
    dataHora = DateTime.parse(json['dataHora'] as String);
    total = json['total'];
  }
}
