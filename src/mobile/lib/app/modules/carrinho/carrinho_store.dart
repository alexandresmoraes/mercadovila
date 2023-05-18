import 'package:mobx/mobx.dart';

part 'carrinho_store.g.dart';

class CarrinhoStore = _CarrinhoStoreBase with _$CarrinhoStore;

abstract class _CarrinhoStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
