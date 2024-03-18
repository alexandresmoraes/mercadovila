// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compras_carrinho_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ComprasCarrinhoStore on ComprasCarrinhoStoreBase, Store {
  Computed<bool>? _$isSelectedItemComputed;

  @override
  bool get isSelectedItem =>
      (_$isSelectedItemComputed ??= Computed<bool>(() => super.isSelectedItem,
              name: 'ComprasCarrinhoStoreBase.isSelectedItem'))
          .value;
  Computed<bool>? _$isValidCarrinhoComprasComputed;

  @override
  bool get isValidCarrinhoCompras => (_$isValidCarrinhoComprasComputed ??=
          Computed<bool>(() => super.isValidCarrinhoCompras,
              name: 'ComprasCarrinhoStoreBase.isValidCarrinhoCompras'))
      .value;
  Computed<double>? _$subTotalComputed;

  @override
  double get subTotal =>
      (_$subTotalComputed ??= Computed<double>(() => super.subTotal,
              name: 'ComprasCarrinhoStoreBase.subTotal'))
          .value;
  Computed<double>? _$totalComputed;

  @override
  double get total => (_$totalComputed ??= Computed<double>(() => super.total,
          name: 'ComprasCarrinhoStoreBase.total'))
      .value;

  late final _$carrinhoComprasItensAtom = Atom(
      name: 'ComprasCarrinhoStoreBase.carrinhoComprasItens', context: context);

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
      Atom(name: 'ComprasCarrinhoStoreBase.selectedItem', context: context);

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
      Atom(name: 'ComprasCarrinhoStoreBase.isLoading', context: context);

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

  late final _$ComprasCarrinhoStoreBaseActionController =
      ActionController(name: 'ComprasCarrinhoStoreBase', context: context);

  @override
  void clearSelectedItem() {
    final _$actionInfo = _$ComprasCarrinhoStoreBaseActionController.startAction(
        name: 'ComprasCarrinhoStoreBase.clearSelectedItem');
    try {
      return super.clearSelectedItem();
    } finally {
      _$ComprasCarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectItem(ProdutoDto item) {
    final _$actionInfo = _$ComprasCarrinhoStoreBaseActionController.startAction(
        name: 'ComprasCarrinhoStoreBase.setSelectItem');
    try {
      return super.setSelectItem(item);
    } finally {
      _$ComprasCarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  CarrinhoComprasItemDto addCarrinhoComprasItem() {
    final _$actionInfo = _$ComprasCarrinhoStoreBaseActionController.startAction(
        name: 'ComprasCarrinhoStoreBase.addCarrinhoComprasItem');
    try {
      return super.addCarrinhoComprasItem();
    } finally {
      _$ComprasCarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void refresh() {
    final _$actionInfo = _$ComprasCarrinhoStoreBaseActionController.startAction(
        name: 'ComprasCarrinhoStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$ComprasCarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  CarrinhoComprasItemDto? addCarrinhoComprasItemExistente(String produtoId) {
    final _$actionInfo = _$ComprasCarrinhoStoreBaseActionController.startAction(
        name: 'ComprasCarrinhoStoreBase.addCarrinhoComprasItemExistente');
    try {
      return super.addCarrinhoComprasItemExistente(produtoId);
    } finally {
      _$ComprasCarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool removerCarrinhoComprasItem(String produtoId, bool removeAll) {
    final _$actionInfo = _$ComprasCarrinhoStoreBaseActionController.startAction(
        name: 'ComprasCarrinhoStoreBase.removerCarrinhoComprasItem');
    try {
      return super.removerCarrinhoComprasItem(produtoId, removeAll);
    } finally {
      _$ComprasCarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
carrinhoComprasItens: ${carrinhoComprasItens},
selectedItem: ${selectedItem},
isLoading: ${isLoading},
isSelectedItem: ${isSelectedItem},
isValidCarrinhoCompras: ${isValidCarrinhoCompras},
subTotal: ${subTotal},
total: ${total}
    ''';
  }
}
