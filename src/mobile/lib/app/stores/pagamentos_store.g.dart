// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagamentos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PagamentosStore on PagamentosStoreBase, Store {
  late final _$pagamentoDetalheDtoAtom =
      Atom(name: 'PagamentosStoreBase.pagamentoDetalheDto', context: context);

  @override
  PagamentoDetalheDto? get pagamentoDetalheDto {
    _$pagamentoDetalheDtoAtom.reportRead();
    return super.pagamentoDetalheDto;
  }

  @override
  set pagamentoDetalheDto(PagamentoDetalheDto? value) {
    _$pagamentoDetalheDtoAtom.reportWrite(value, super.pagamentoDetalheDto, () {
      super.pagamentoDetalheDto = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'PagamentosStoreBase.isLoading', context: context);

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
      AsyncAction('PagamentosStoreBase.load', context: context);

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
pagamentoDetalheDto: ${pagamentoDetalheDto},
isLoading: ${isLoading}
    ''';
  }
}
