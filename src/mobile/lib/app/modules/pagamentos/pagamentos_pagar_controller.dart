import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mercadovila/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:mercadovila/app/utils/models/pagamento/realizar_pagamento_model.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_pagamentos_repository.dart';
import 'package:mercadovila/app/utils/widgets/global_snackbar.dart';

part 'pagamentos_pagar_controller.g.dart';

class PagamentosPagarController = PagamentosPagarControllerBase with _$PagamentosPagarController;

abstract class PagamentosPagarControllerBase with Store {
  TextEditingController usuarioEditingController = TextEditingController();
  TextEditingController tipoPagamentoController = TextEditingController();
  TextEditingController mesReferenciaController = TextEditingController();

  Map<int, String> enumTipoPagamento = {
    0: 'Desconto em folha',
    1: 'Dinheiro',
  };

  Map<int, String> enumMesReferencia = {
    1: 'Janeiro',
    2: 'Fevereiro',
    3: 'Março',
    4: 'Abril',
    5: 'Maio',
    6: 'Junho',
    7: 'Julho',
    8: 'Agosto',
    9: 'Setembro',
    10: 'Outubro',
    11: 'Novembro',
    12: 'Dezembro'
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
  bool get isTipoPagamentoSelected => tipoPagamento != null;

  @observable
  int? mesReferencia;

  @action
  void setMesReferencia(int mesReferenciaId) {
    mesReferencia = mesReferenciaId;
    mesReferenciaController.text = enumMesReferencia[mesReferenciaId]!;
  }

  @action
  void clearMesReferencia() {
    mesReferenciaController.text = "";
    mesReferencia = null;
  }

  @computed
  bool get isMesReferenciaSelected => mesReferencia != null;

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
    return isPagamentoDetalheSelected && isTipoPagamentoSelected && isValidPagamento && isMesReferenciaSelected;
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
          mesReferencia: mesReferencia!,
          vendasId: pagamentoDetalheDto!.vendas.map((e) => e.vendaId).toList(),
        ),
      );

      await result.fold((fail) {
        if (fail.statusCode == 400) {
          var message = fail.getErrorNotProperty();
          if (message.isNotEmpty) GlobalSnackbar.error(message);
        }
      }, (response) async {
        GlobalSnackbar.success('Pagamento realizado com sucesso');
        Modular.to.pop(true);
      });
    } finally {
      isLoadingRealizarPagamento = false;
    }
  }
}
