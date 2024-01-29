import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/models/pagamento/realizar_pagamento_model.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_pagamentos_repository.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

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
  bool get isValidPagamento {
    return pagamentoDetalheDto!.total > 0;
  }

  @computed
  bool get isValid {
    return isPagamentoDetalheSelected && isTipoPagamentoSelected && isValidPagamento;
  }

  @computed
  bool get isPagamentoDetalheSelected {
    return pagamentoDetalheDto != null;
  }

  @observable
  bool isLoadingRealizarPagamento = false;

  @action
  Future<void> realizarPagamento() async {
    try {
      isLoadingRealizarPagamento = true;

      var pagamentoRepository = Modular.get<IPagamentosRepository>();

      var result = await pagamentoRepository.realizarPagamento(
        RealizarPagamentoModel(
          userId: pagamentoDetalheDto!.compradorUserId,
          tipoPagamento: tipoPagamento!,
          vendasId: pagamentoDetalheDto!.vendas.map((e) => e.vendaId).toList(),
        ),
      );

      await result.fold((fail) {
        if (fail.statusCode == 400) {
          var message = fail.getErrorNotProperty();
          if (message.isNotEmpty) GlobalSnackbar.error(message);
        }
      }, (response) async {
        GlobalSnackbar.success('Pagamento realizado com sucesso!');
        Modular.to.pop(true);
      });
    } finally {
      isLoadingRealizarPagamento = false;
    }
  }
}