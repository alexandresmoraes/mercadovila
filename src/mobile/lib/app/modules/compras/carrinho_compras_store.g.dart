// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrinho_compras_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarrinhoComprasStore on CarrinhoComprasStoreBase, Store {
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

  late final _$carrinhoComprasDtoAtom = Atom(
      name: 'CarrinhoComprasStoreBase.carrinhoComprasDto', context: context);

  @override
  CarrinhoComprasDto? get carrinhoComprasDto {
    _$carrinhoComprasDtoAtom.reportRead();
    return super.carrinhoComprasDto;
  }

  @override
  set carrinhoComprasDto(CarrinhoComprasDto? value) {
    _$carrinhoComprasDtoAtom.reportWrite(value, super.carrinhoComprasDto, () {
      super.carrinhoComprasDto = value;
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

  late final _$loadAsyncAction =
      AsyncAction('CarrinhoComprasStoreBase.load', context: context);

  @override
  Future<CarrinhoComprasDto> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
carrinhoComprasItens: ${carrinhoComprasItens},
carrinhoComprasDto: ${carrinhoComprasDto},
isLoading: ${isLoading}
    ''';
  }
}
