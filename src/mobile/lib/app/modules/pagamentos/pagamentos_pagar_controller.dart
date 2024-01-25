import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_pagamentos_repository.dart';

part 'pagamentos_pagar_controller.g.dart';

class PagamentosPagarController = PagamentosPagarControllerBase with _$PagamentosPagarController;

abstract class PagamentosPagarControllerBase with Store {
  TextEditingController usuarioEditingController = TextEditingController();
  TextEditingController tipoPagamentoController = TextEditingController();

  Map<int, String> enumTipoPagamento = {
    0: 'Desconto em folha',
    1: 'Dinheiro',
  };

  @observable
  int? tipoPagamento;

  @action
  void setTipoPagamento(int tipoPagamentoId) {
    tipoPagamento = tipoPagamentoId;
    tipoPagamentoController.text = enumTipoPagamento[tipoPagamento]!;
  }

  @action
  void clearTipoPagamento() {
    tipoPagamentoController.text = "";
    tipoPagamento = null;
  }

  @computed
  bool get isTipoPagamentoSelected {
    return tipoPagamento != null;
  }

  @observable
  PagamentoDetalheDto? pagamentoDetalheDto;

  @action
  Future<void> load(String userId, String username) async {
    pagamentoDetalheDto = await Modular.get<IPagamentosRepository>().getPagamentoDetalhePorUsuario(userId);
    usuarioEditingController.text = username;
  }

  @action
  void clearPagamentoDetalhe() {
    pagamentoDetalheDto = null;
    usuarioEditingController.text = "";
    clearTipoPagamento();
  }

  @computed
  bool get isValid {
    return isPagamentoDetalheSelected && isTipoPagamentoSelected && pagamentoDetalheDto!.total > 0;
  }

  @computed
  bool get isPagamentoDetalheSelected {
    return pagamentoDetalheDto != null;
  }
}
