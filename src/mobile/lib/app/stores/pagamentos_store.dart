import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_pagamentos_repository.dart';

part 'pagamentos_store.g.dart';

class PagamentosStore = PagamentosStoreBase with _$PagamentosStore;

abstract class PagamentosStoreBase with Store {
  @observable
  PagamentoDetalheDto? pagamentoDetalheDto;

  @observable
  bool isLoading = false;

  @action
  Future<void> load() async {
    try {
      isLoading = true;

      pagamentoDetalheDto = await Modular.get<IPagamentosRepository>().getPagamentoDetalheMe();
    } finally {
      isLoading = false;
    }
  }
}
