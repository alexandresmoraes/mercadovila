import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_pagamentos_repository.dart';

part 'pagamentos_pagar_controller.g.dart';

class PagamentosPagarController = PagamentosPagarControllerBase with _$PagamentosPagarController;

abstract class PagamentosPagarControllerBase with Store {
  TextEditingController usuarioEditingController = TextEditingController();

  Map<int, String> enumTipoPagamento = {
    0: 'Desconto em folha',
    1: 'Dinheiro',
  };

  @observable
  PagamentoDetalheDto? pagamentoDetalheDto;

  @action
  Future<void> load(String userId) async {
    pagamentoDetalheDto = await Modular.get<IPagamentosRepository>().getPagamentoDetalhePorUsuario(userId);
  }

  @action
  void clear() {
    pagamentoDetalheDto = null;
    usuarioEditingController.text = "";
  }

  @computed
  bool get isValid {
    return isSelected && pagamentoDetalheDto!.total > 0;
  }

  @computed
  bool get isSelected {
    return pagamentoDetalheDto != null;
  }
}
