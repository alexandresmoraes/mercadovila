enum EnumTipoPagamento {
  descontoEmFolha,
  dinheiro,
}

enum EnumStatusPagamento {
  ativo,
  cancelado,
}

enum EnumMesReferencia {
  janeiro(1),
  fevereiro(2),
  marco(3),
  abril(4),
  maio(5),
  junho(6),
  julho(7),
  agosto(8),
  setembro(9),
  outubro(10),
  novembro(11),
  dezembro(12);

  const EnumMesReferencia(this.value);

  final int value;
}

class PagamentosDto {
  PagamentosDto({
    required this.compradorUserId,
    required this.compradorNome,
    this.compradorFotoUrl,
    required this.pagamentoId,
    required this.pagamentoDataHora,
    required this.pagamentoTipo,
    required this.pagamentoStatus,
    required this.mesReferencia,
    required this.pagamentoValor,
    required this.recebidoPorUserId,
    required this.recebidoPor,
    this.canceladoPorUserId,
    this.canceladoPor,
  });
  late final String compradorUserId;
  late final String compradorNome;
  late final String? compradorFotoUrl;
  late final String compradorEmail;
  late final int pagamentoId;
  late final DateTime pagamentoDataHora;
  late final num pagamentoTipo;
  late final num pagamentoStatus;
  late final num mesReferencia;
  late final num pagamentoValor;
  late final String recebidoPorUserId;
  late final String recebidoPor;
  late final DateTime? dataCancelamento;
  late final String? canceladoPorUserId;
  late final String? canceladoPor;

  PagamentosDto.fromJson(Map<String, dynamic> json) {
    compradorUserId = json['compradorUserId'];
    compradorNome = json['compradorNome'];
    compradorFotoUrl = json['compradorFotoUrl'];
    compradorEmail = json['compradorEmail'];
    pagamentoId = json['pagamentoId'];
    pagamentoDataHora = DateTime.parse(json['pagamentoDataHora'] as String);
    pagamentoTipo = json['pagamentoTipo'];
    pagamentoStatus = json['pagamentoStatus'];
    mesReferencia = json['mesReferencia'];
    pagamentoValor = json['pagamentoValor'];
    recebidoPorUserId = json['recebidoPorUserId'];
    recebidoPor = json['recebidoPor'];
    dataCancelamento = json['dataCancelamento'] != null ? DateTime.parse(json['dataCancelamento']) : null;
    canceladoPorUserId = json['canceladoPorUserId'];
    canceladoPor = json['canceladoPor'];
  }
}
