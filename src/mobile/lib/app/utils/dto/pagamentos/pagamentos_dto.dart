enum EnumTipoPagamento {
  descontoEmFolha,
  dinheiro,
}

enum EnumStatusPagamento {
  ativo,
  cancelado,
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
    pagamentoValor = json['pagamentoValor'];
    recebidoPorUserId = json['recebidoPorUserId'];
    recebidoPor = json['recebidoPor'];
    dataCancelamento = json['dataCancelamento'] != null ? DateTime.parse(json['dataCancelamento']) : null;
    canceladoPorUserId = json['canceladoPorUserId'];
    canceladoPor = json['canceladoPor'];
  }
}
