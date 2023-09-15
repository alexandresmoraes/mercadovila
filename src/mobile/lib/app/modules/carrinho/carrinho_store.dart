import 'package:mobx/mobx.dart';

part 'carrinho_store.g.dart';

class CarrinhoStore = CarrinhoStoreBase with _$CarrinhoStore;

abstract class CarrinhoStoreBase with Store {
  @observable
  bool isFormaPagamentoSelected = false;

  @observable
  bool selectOpcaoPagamento = false;

  @action
  void setSelectOpcaoPagamento(bool value) {
    selectOpcaoPagamento = value;
  }
}
