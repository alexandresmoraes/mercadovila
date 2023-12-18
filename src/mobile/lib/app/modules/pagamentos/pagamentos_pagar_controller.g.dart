// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagamentos_pagar_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PagamentosPagarController on PagamentosPagarControllerBase, Store {
  Computed<bool>? _$isValidComputed;

  @override
  bool get isValid => (_$isValidComputed ??= Computed<bool>(() => super.isValid,
          name: 'PagamentosPagarControllerBase.isValid'))
      .value;
  Computed<bool>? _$isSelectedComputed;

  @override
  bool get isSelected =>
      (_$isSelectedComputed ??= Computed<bool>(() => super.isSelected,
              name: 'PagamentosPagarControllerBase.isSelected'))
          .value;

  late final _$pagamentoDetalheDtoAtom = Atom(
      name: 'PagamentosPagarControllerBase.pagamentoDetalheDto',
      context: context);

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

  late final _$loadAsyncAction =
      AsyncAction('PagamentosPagarControllerBase.load', context: context);

  @override
  Future<void> load(String userId) {
    return _$loadAsyncAction.run(() => super.load(userId));
  }

  late final _$PagamentosPagarControllerBaseActionController =
      ActionController(name: 'PagamentosPagarControllerBase', context: context);

  @override
  void clear() {
    final _$actionInfo = _$PagamentosPagarControllerBaseActionController
        .startAction(name: 'PagamentosPagarControllerBase.clear');
    try {
      return super.clear();
    } finally {
      _$PagamentosPagarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pagamentoDetalheDto: ${pagamentoDetalheDto},
isValid: ${isValid},
isSelected: ${isSelected}
    ''';
  }
}
