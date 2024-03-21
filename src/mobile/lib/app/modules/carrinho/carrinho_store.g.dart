// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrinho_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarrinhoStore on CarrinhoStoreBase, Store {
  Computed<bool>? _$isValidCarrinhoComputed;

  @override
  bool get isValidCarrinho =>
      (_$isValidCarrinhoComputed ??= Computed<bool>(() => super.isValidCarrinho,
              name: 'CarrinhoStoreBase.isValidCarrinho'))
          .value;

  late final _$isDescontoSalarioAtom =
      Atom(name: 'CarrinhoStoreBase.isDescontoSalario', context: context);

  @override
  bool get isDescontoSalario {
    _$isDescontoSalarioAtom.reportRead();
    return super.isDescontoSalario;
  }

  @override
  set isDescontoSalario(bool value) {
    _$isDescontoSalarioAtom.reportWrite(value, super.isDescontoSalario, () {
      super.isDescontoSalario = value;
    });
  }

  late final _$isDinheiroAtom =
      Atom(name: 'CarrinhoStoreBase.isDinheiro', context: context);

  @override
  bool get isDinheiro {
    _$isDinheiroAtom.reportRead();
    return super.isDinheiro;
  }

  @override
  set isDinheiro(bool value) {
    _$isDinheiroAtom.reportWrite(value, super.isDinheiro, () {
      super.isDinheiro = value;
    });
  }

  late final _$carrinhoItensAtom =
      Atom(name: 'CarrinhoStoreBase.carrinhoItens', context: context);

  @override
  ObservableList<CarrinhoItemDto> get carrinhoItens {
    _$carrinhoItensAtom.reportRead();
    return super.carrinhoItens;
  }

  @override
  set carrinhoItens(ObservableList<CarrinhoItemDto> value) {
    _$carrinhoItensAtom.reportWrite(value, super.carrinhoItens, () {
      super.carrinhoItens = value;
    });
  }

  late final _$carrinhoDtoAtom =
      Atom(name: 'CarrinhoStoreBase.carrinhoDto', context: context);

  @override
  CarrinhoDto? get carrinhoDto {
    _$carrinhoDtoAtom.reportRead();
    return super.carrinhoDto;
  }

  @override
  set carrinhoDto(CarrinhoDto? value) {
    _$carrinhoDtoAtom.reportWrite(value, super.carrinhoDto, () {
      super.carrinhoDto = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'CarrinhoStoreBase.isLoading', context: context);

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
      AsyncAction('CarrinhoStoreBase.load', context: context);

  @override
  Future<CarrinhoDto> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$CarrinhoStoreBaseActionController =
      ActionController(name: 'CarrinhoStoreBase', context: context);

  @override
  void setDescontoSalario() {
    final _$actionInfo = _$CarrinhoStoreBaseActionController.startAction(
        name: 'CarrinhoStoreBase.setDescontoSalario');
    try {
      return super.setDescontoSalario();
    } finally {
      _$CarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDinheiro() {
    final _$actionInfo = _$CarrinhoStoreBaseActionController.startAction(
        name: 'CarrinhoStoreBase.setDinheiro');
    try {
      return super.setDinheiro();
    } finally {
      _$CarrinhoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDescontoSalario: ${isDescontoSalario},
isDinheiro: ${isDinheiro},
carrinhoItens: ${carrinhoItens},
carrinhoDto: ${carrinhoDto},
isLoading: ${isLoading},
isValidCarrinho: ${isValidCarrinho}
    ''';
  }
}
