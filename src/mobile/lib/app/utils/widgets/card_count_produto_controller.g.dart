// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_count_produto_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CardCountProdutoController on CardCountProdutoControllerBase, Store {
  late final _$quantidadeAtom =
      Atom(name: 'CardCountProdutoControllerBase.quantidade', context: context);

  @override
  int get quantidade {
    _$quantidadeAtom.reportRead();
    return super.quantidade;
  }

  @override
  set quantidade(int value) {
    _$quantidadeAtom.reportWrite(value, super.quantidade, () {
      super.quantidade = value;
    });
  }

  late final _$adicionarCarrinhoItemAsyncAction = AsyncAction(
      'CardCountProdutoControllerBase.adicionarCarrinhoItem',
      context: context);

  @override
  Future<void> adicionarCarrinhoItem() {
    return _$adicionarCarrinhoItemAsyncAction
        .run(() => super.adicionarCarrinhoItem());
  }

  late final _$removerCarrinhoItemAsyncAction = AsyncAction(
      'CardCountProdutoControllerBase.removerCarrinhoItem',
      context: context);

  @override
  Future<void> removerCarrinhoItem() {
    return _$removerCarrinhoItemAsyncAction
        .run(() => super.removerCarrinhoItem());
  }

  @override
  String toString() {
    return '''
quantidade: ${quantidade}
    ''';
  }
}
