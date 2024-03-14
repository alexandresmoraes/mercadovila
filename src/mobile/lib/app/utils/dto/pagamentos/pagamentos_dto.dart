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

  PagamentosDto.fromJson(Map<String, dynamic> json) {
    compradorUserId = json['compradorUserId'];
    compradorNome = json['compradorNome'];
    compradorFotoUrl = json['compradorFotoUrl'];
    compradorEmail = json['compradorEmail'];
    pagamentoId = json['pagamentoId'];
    pagamentoDataHora = json['pagamentoDataHora'];
    pagamentoTipo = json['pagamentoTipo'];
    pagamentoStatus = json['pagamentoStatus'];
    pagamentoValor = json['pagamentoValor'];
  }
}
