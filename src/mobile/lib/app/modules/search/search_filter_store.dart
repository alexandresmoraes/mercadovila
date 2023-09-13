import 'package:mobx/mobx.dart';

part 'search_filter_store.g.dart';

enum ECatalogoTodosQueryOrder {
  nameAsc,
  nameDesc,
  priceHighToLow,
  priceLowToHigh,
}

class SearchFilterStore = SearchFilterStoreBase with _$SearchFilterStore;

abstract class SearchFilterStoreBase with Store {
  @observable
  int selectOrder = 0;
  @action
  void setSelectedOrder(int value) {
    selectOrder = value;
  }

  @observable
  int totalProdutos = 0;
  @action
  void setTotalProdutos(int value) {
    totalProdutos = value;
  }

  @observable
  bool inStock = true;

  @observable
  bool outOfStock = false;

  @action
  void clean() {
    selectOrder = 0;
    inStock = true;
    outOfStock = false;
  }
}
