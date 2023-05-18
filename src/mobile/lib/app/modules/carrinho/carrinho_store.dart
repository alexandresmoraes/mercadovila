import 'package:mobx/mobx.dart';

part 'carrinho_store.g.dart';

class CartStore = _CarrinhoStoreBase with _$CartStore;

abstract class _CarrinhoStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
