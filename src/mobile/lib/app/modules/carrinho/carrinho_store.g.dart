// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrinho_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarrinhoStore on CarrinhoStoreBase, Store {
  late final _$isFormaPagamentoSelectedAtom = Atom(
      name: 'CarrinhoStoreBase.isFormaPagamentoSelected', context: context);

  @override
  bool get isFormaPagamentoSelected {
    _$isFormaPagamentoSelectedAtom.reportRead();
    return super.isFormaPagamentoSelected;
  }

  @override
  set isFormaPagamentoSelected(bool value) {
    _$isFormaPagamentoSelectedAtom
        .reportWrite(value, super.isFormaPagamentoSelected, () {
      super.isFormaPagamentoSelected = value;
    });
  }

  late final _$selectOpcaoPagamentoAtom =
      Atom(name: 'CarrinhoStoreBase.selectOpcaoPagamento', context: context);

  @override
  bool get selectOpcaoPagamento {
    _$selectOpcaoPagamentoAtom.reportRead();
    return super.selectOpcaoPagamento;
  }

  @override
  set selectOpcaoPagamento(bool value) {
    _$selectOpcaoPagamentoAtom.reportWrite(value, super.selectOpcaoPagamento,
        () {
      super.selectOpcaoPagamento = value;
    });
  }

  late final _$CarrinhoStoreBaseActionController =
      ActionController(name: 'CarrinhoStoreBase', context: context);

  @override
  void toggleSelectOpcaoPagamento() {
    final _$actionInfo = _$CarrinhoStoreBaseActionController.startAction(
        name: 'CarrinhoStoreBase.toggleSelectOpcaoPagamento');
    try {
      return super.toggleSelectOpcaoPagamento();
    } finally {
      _$CarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isFormaPagamentoSelected: ${isFormaPagamentoSelected},
selectOpcaoPagamento: ${selectOpcaoPagamento}
    ''';
  }
}
