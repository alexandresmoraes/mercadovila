// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagamentos_pagar_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PagamentosPagarController on PagamentosPagarControllerBase, Store {
  Computed<bool>? _$isTipoPagamentoSelectedComputed;

  @override
  bool get isTipoPagamentoSelected => (_$isTipoPagamentoSelectedComputed ??=
          Computed<bool>(() => super.isTipoPagamentoSelected,
              name: 'PagamentosPagarControllerBase.isTipoPagamentoSelected'))
      .value;
  Computed<bool>? _$isValidComputed;

  @override
  bool get isValid => (_$isValidComputed ??= Computed<bool>(() => super.isValid,
          name: 'PagamentosPagarControllerBase.isValid'))
      .value;
  Computed<bool>? _$isPagamentoDetalheSelectedComputed;

  @override
  bool get isPagamentoDetalheSelected =>
      (_$isPagamentoDetalheSelectedComputed ??= Computed<bool>(
              () => super.isPagamentoDetalheSelected,
              name: 'PagamentosPagarControllerBase.isPagamentoDetalheSelected'))
          .value;

  late final _$tipoPagamentoAtom = Atom(
      name: 'PagamentosPagarControllerBase.tipoPagamento', context: context);

  @override
  int? get tipoPagamento {
    _$tipoPagamentoAtom.reportRead();
    return super.tipoPagamento;
  }

  @override
  set tipoPagamento(int? value) {
    _$tipoPagamentoAtom.reportWrite(value, super.tipoPagamento, () {
      super.tipoPagamento = value;
    });
  }

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

  late final _$isLoadingRealizarPagamentoAtom = Atom(
      name: 'PagamentosPagarControllerBase.isLoadingRealizarPagamento',
      context: context);

  @override
  bool get isLoadingRealizarPagamento {
    _$isLoadingRealizarPagamentoAtom.reportRead();
    return super.isLoadingRealizarPagamento;
  }

  @override
  set isLoadingRealizarPagamento(bool value) {
    _$isLoadingRealizarPagamentoAtom
        .reportWrite(value, super.isLoadingRealizarPagamento, () {
      super.isLoadingRealizarPagamento = value;
    });
  }

  late final _$loadAsyncAction =
      AsyncAction('PagamentosPagarControllerBase.load', context: context);

  @override
  Future<void> load(String userId, String username) {
    return _$loadAsyncAction.run(() => super.load(userId, username));
  }

  late final _$realizarPagamentoAsyncAction = AsyncAction(
      'PagamentosPagarControllerBase.realizarPagamento',
      context: context);

  @override
  Future<void> realizarPagamento() {
    return _$realizarPagamentoAsyncAction.run(() => super.realizarPagamento());
  }

  late final _$PagamentosPagarControllerBaseActionController =
      ActionController(name: 'PagamentosPagarControllerBase', context: context);

  @override
  void setTipoPagamento(int tipoPagamentoId) {
    final _$actionInfo = _$PagamentosPagarControllerBaseActionController
        .startAction(name: 'PagamentosPagarControllerBase.setTipoPagamento');
    try {
      return super.setTipoPagamento(tipoPagamentoId);
    } finally {
      _$PagamentosPagarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearTipoPagamento() {
    final _$actionInfo = _$PagamentosPagarControllerBaseActionController
        .startAction(name: 'PagamentosPagarControllerBase.clearTipoPagamento');
    try {
      return super.clearTipoPagamento();
    } finally {
      _$PagamentosPagarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPagamentoDetalhe() {
    final _$actionInfo =
        _$PagamentosPagarControllerBaseActionController.startAction(
            name: 'PagamentosPagarControllerBase.clearPagamentoDetalhe');
    try {
      return super.clearPagamentoDetalhe();
    } finally {
      _$PagamentosPagarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tipoPagamento: ${tipoPagamento},
pagamentoDetalheDto: ${pagamentoDetalheDto},
isLoadingRealizarPagamento: ${isLoadingRealizarPagamento},
isTipoPagamentoSelected: ${isTipoPagamentoSelected},
isValid: ${isValid},
isPagamentoDetalheSelected: ${isPagamentoDetalheSelected}
    ''';
  }
}
