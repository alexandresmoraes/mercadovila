// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchFilterStore on SearchFilterStoreBase, Store {
  late final _$selectOrderAtom =
      Atom(name: 'SearchFilterStoreBase.selectOrder', context: context);

  @override
  int get selectOrder {
    _$selectOrderAtom.reportRead();
    return super.selectOrder;
  }

  @override
  set selectOrder(int value) {
    _$selectOrderAtom.reportWrite(value, super.selectOrder, () {
      super.selectOrder = value;
    });
  }

  late final _$totalProdutosAtom =
      Atom(name: 'SearchFilterStoreBase.totalProdutos', context: context);

  @override
  int get totalProdutos {
    _$totalProdutosAtom.reportRead();
    return super.totalProdutos;
  }

  @override
  set totalProdutos(int value) {
    _$totalProdutosAtom.reportWrite(value, super.totalProdutos, () {
      super.totalProdutos = value;
    });
  }

  late final _$inStockAtom =
      Atom(name: 'SearchFilterStoreBase.inStock', context: context);

  @override
  bool get inStock {
    _$inStockAtom.reportRead();
    return super.inStock;
  }

  @override
  set inStock(bool value) {
    _$inStockAtom.reportWrite(value, super.inStock, () {
      super.inStock = value;
    });
  }

  late final _$outOfStockAtom =
      Atom(name: 'SearchFilterStoreBase.outOfStock', context: context);

  @override
  bool get outOfStock {
    _$outOfStockAtom.reportRead();
    return super.outOfStock;
  }

  @override
  set outOfStock(bool value) {
    _$outOfStockAtom.reportWrite(value, super.outOfStock, () {
      super.outOfStock = value;
    });
  }

  late final _$SearchFilterStoreBaseActionController =
      ActionController(name: 'SearchFilterStoreBase', context: context);

  @override
  void setSelectedOrder(int value) {
    final _$actionInfo = _$SearchFilterStoreBaseActionController.startAction(
        name: 'SearchFilterStoreBase.setSelectedOrder');
    try {
      return super.setSelectedOrder(value);
    } finally {
      _$SearchFilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalProdutos(int value) {
    final _$actionInfo = _$SearchFilterStoreBaseActionController.startAction(
        name: 'SearchFilterStoreBase.setTotalProdutos');
    try {
      return super.setTotalProdutos(value);
    } finally {
      _$SearchFilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clean() {
    final _$actionInfo = _$SearchFilterStoreBaseActionController.startAction(
        name: 'SearchFilterStoreBase.clean');
    try {
      return super.clean();
    } finally {
      _$SearchFilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectOrder: ${selectOrder},
totalProdutos: ${totalProdutos},
inStock: ${inStock},
outOfStock: ${outOfStock}
    ''';
  }
}
