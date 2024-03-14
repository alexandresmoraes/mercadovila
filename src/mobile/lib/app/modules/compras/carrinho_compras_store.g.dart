// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrinho_compras_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarrinhoComprasStore on CarrinhoComprasStoreBase, Store {
  Computed<bool>? _$isSelectedItemComputed;

  @override
  bool get isSelectedItem =>
      (_$isSelectedItemComputed ??= Computed<bool>(() => super.isSelectedItem,
              name: 'CarrinhoComprasStoreBase.isSelectedItem'))
          .value;
  Computed<bool>? _$isValidCarrinhoComprasComputed;

  @override
  bool get isValidCarrinhoCompras => (_$isValidCarrinhoComprasComputed ??=
          Computed<bool>(() => super.isValidCarrinhoCompras,
              name: 'CarrinhoComprasStoreBase.isValidCarrinhoCompras'))
      .value;

  late final _$carrinhoComprasItensAtom = Atom(
      name: 'CarrinhoComprasStoreBase.carrinhoComprasItens', context: context);

  @override
  ObservableList<CarrinhoComprasItemDto> get carrinhoComprasItens {
    _$carrinhoComprasItensAtom.reportRead();
    return super.carrinhoComprasItens;
  }

  @override
  set carrinhoComprasItens(ObservableList<CarrinhoComprasItemDto> value) {
    _$carrinhoComprasItensAtom.reportWrite(value, super.carrinhoComprasItens,
        () {
      super.carrinhoComprasItens = value;
    });
  }

  late final _$selectedItemAtom =
      Atom(name: 'CarrinhoComprasStoreBase.selectedItem', context: context);

  @override
  ProdutoDto? get selectedItem {
    _$selectedItemAtom.reportRead();
    return super.selectedItem;
  }

  @override
  set selectedItem(ProdutoDto? value) {
    _$selectedItemAtom.reportWrite(value, super.selectedItem, () {
      super.selectedItem = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'CarrinhoComprasStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$subTotalAtom =
      Atom(name: 'CarrinhoComprasStoreBase.subTotal', context: context);

  @override
  double get subTotal {
    _$subTotalAtom.reportRead();
    return super.subTotal;
  }

  @override
  set subTotal(double value) {
    _$subTotalAtom.reportWrite(value, super.subTotal, () {
      super.subTotal = value;
    });
  }

  late final _$totalAtom =
      Atom(name: 'CarrinhoComprasStoreBase.total', context: context);

  @override
  double get total {
    _$totalAtom.reportRead();
    return super.total;
  }

  @override
  set total(double value) {
    _$totalAtom.reportWrite(value, super.total, () {
      super.total = value;
    });
  }

  late final _$CarrinhoComprasStoreBaseActionController =
      ActionController(name: 'CarrinhoComprasStoreBase', context: context);

  @override
  void clearSelectedItem() {
    final _$actionInfo = _$CarrinhoComprasStoreBaseActionController.startAction(
        name: 'CarrinhoComprasStoreBase.clearSelectedItem');
    try {
      return super.clearSelectedItem();
    } finally {
      _$CarrinhoComprasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectItem(ProdutoDto item) {
    final _$actionInfo = _$CarrinhoComprasStoreBaseActionController.startAction(
        name: 'CarrinhoComprasStoreBase.setSelectItem');
    try {
      return super.setSelectItem(item);
    } finally {
      _$CarrinhoComprasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addCarrinhoComprasItem() {
    final _$actionInfo = _$CarrinhoComprasStoreBaseActionController.startAction(
        name: 'CarrinhoComprasStoreBase.addCarrinhoComprasItem');
    try {
      return super.addCarrinhoComprasItem();
    } finally {
      _$CarrinhoComprasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool addCarrinhoComprasItemExistente(String produtoId) {
    final _$actionInfo = _$CarrinhoComprasStoreBaseActionController.startAction(
        name: 'CarrinhoComprasStoreBase.addCarrinhoComprasItemExistente');
    try {
      return super.addCarrinhoComprasItemExistente(produtoId);
    } finally {
      _$CarrinhoComprasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool removerCarrinhoComprasItem(String produtoId, bool removeAll) {
    final _$actionInfo = _$CarrinhoComprasStoreBaseActionController.startAction(
        name: 'CarrinhoComprasStoreBase.removerCarrinhoComprasItem');
    try {
      return super.removerCarrinhoComprasItem(produtoId, removeAll);
    } finally {
      _$CarrinhoComprasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void update() {
    final _$actionInfo = _$CarrinhoComprasStoreBaseActionController.startAction(
        name: 'CarrinhoComprasStoreBase.update');
    try {
      return super.update();
    } finally {
      _$CarrinhoComprasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
carrinhoComprasItens: ${carrinhoComprasItens},
selectedItem: ${selectedItem},
isLoading: ${isLoading},
subTotal: ${subTotal},
total: ${total},
isSelectedItem: ${isSelectedItem},
isValidCarrinhoCompras: ${isValidCarrinhoCompras}
    ''';
  }
}
