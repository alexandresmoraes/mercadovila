// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produtos_edit_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProdutosEditController on ProdutosEditControllerBase, Store {
  Computed<String?>? _$getImageUrlErrorComputed;

  @override
  String? get getImageUrlError => (_$getImageUrlErrorComputed ??=
          Computed<String?>(() => super.getImageUrlError,
              name: 'ProdutosEditControllerBase.getImageUrlError'))
      .value;
  Computed<String?>? _$getNomeErrorComputed;

  @override
  String? get getNomeError =>
      (_$getNomeErrorComputed ??= Computed<String?>(() => super.getNomeError,
              name: 'ProdutosEditControllerBase.getNomeError'))
          .value;
  Computed<String?>? _$getDescricaoErrorComputed;

  @override
  String? get getDescricaoError => (_$getDescricaoErrorComputed ??=
          Computed<String?>(() => super.getDescricaoError,
              name: 'ProdutosEditControllerBase.getDescricaoError'))
      .value;
  Computed<String?>? _$getPrecoErrorComputed;

  @override
  String? get getPrecoError =>
      (_$getPrecoErrorComputed ??= Computed<String?>(() => super.getPrecoError,
              name: 'ProdutosEditControllerBase.getPrecoError'))
          .value;
  Computed<String?>? _$getUnidadeMedidaErrorComputed;

  @override
  String? get getUnidadeMedidaError => (_$getUnidadeMedidaErrorComputed ??=
          Computed<String?>(() => super.getUnidadeMedidaError,
              name: 'ProdutosEditControllerBase.getUnidadeMedidaError'))
      .value;
  Computed<String?>? _$getCodigoBarrasErrorComputed;

  @override
  String? get getCodigoBarrasError => (_$getCodigoBarrasErrorComputed ??=
          Computed<String?>(() => super.getCodigoBarrasError,
              name: 'ProdutosEditControllerBase.getCodigoBarrasError'))
      .value;
  Computed<String?>? _$getEstoqueAlvoErrorComputed;

  @override
  String? get getEstoqueAlvoError => (_$getEstoqueAlvoErrorComputed ??=
          Computed<String?>(() => super.getEstoqueAlvoError,
              name: 'ProdutosEditControllerBase.getEstoqueAlvoError'))
      .value;
  Computed<String?>? _$getEstoqueErrorComputed;

  @override
  String? get getEstoqueError => (_$getEstoqueErrorComputed ??=
          Computed<String?>(() => super.getEstoqueError,
              name: 'ProdutosEditControllerBase.getEstoqueError'))
      .value;
  Computed<bool>? _$isValidComputed;

  @override
  bool get isValid => (_$isValidComputed ??= Computed<bool>(() => super.isValid,
          name: 'ProdutosEditControllerBase.isValid'))
      .value;

  late final _$imagePathAtom =
      Atom(name: 'ProdutosEditControllerBase.imagePath', context: context);

  @override
  String? get imagePath {
    _$imagePathAtom.reportRead();
    return super.imagePath;
  }

  @override
  set imagePath(String? value) {
    _$imagePathAtom.reportWrite(value, super.imagePath, () {
      super.imagePath = value;
    });
  }

  late final _$imageUrlAtom =
      Atom(name: 'ProdutosEditControllerBase.imageUrl', context: context);

  @override
  String? get imageUrl {
    _$imageUrlAtom.reportRead();
    return super.imageUrl;
  }

  @override
  set imageUrl(String? value) {
    _$imageUrlAtom.reportWrite(value, super.imageUrl, () {
      super.imageUrl = value;
    });
  }

  late final _$nomeAtom =
      Atom(name: 'ProdutosEditControllerBase.nome', context: context);

  @override
  String? get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String? value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  late final _$_nomeApiErrorAtom =
      Atom(name: 'ProdutosEditControllerBase._nomeApiError', context: context);

  @override
  String? get _nomeApiError {
    _$_nomeApiErrorAtom.reportRead();
    return super._nomeApiError;
  }

  @override
  set _nomeApiError(String? value) {
    _$_nomeApiErrorAtom.reportWrite(value, super._nomeApiError, () {
      super._nomeApiError = value;
    });
  }

  late final _$descricaoAtom =
      Atom(name: 'ProdutosEditControllerBase.descricao', context: context);

  @override
  String? get descricao {
    _$descricaoAtom.reportRead();
    return super.descricao;
  }

  @override
  set descricao(String? value) {
    _$descricaoAtom.reportWrite(value, super.descricao, () {
      super.descricao = value;
    });
  }

  late final _$_descricaoApiErrorAtom = Atom(
      name: 'ProdutosEditControllerBase._descricaoApiError', context: context);

  @override
  String? get _descricaoApiError {
    _$_descricaoApiErrorAtom.reportRead();
    return super._descricaoApiError;
  }

  @override
  set _descricaoApiError(String? value) {
    _$_descricaoApiErrorAtom.reportWrite(value, super._descricaoApiError, () {
      super._descricaoApiError = value;
    });
  }

  late final _$precoAtom =
      Atom(name: 'ProdutosEditControllerBase.preco', context: context);

  @override
  String? get preco {
    _$precoAtom.reportRead();
    return super.preco;
  }

  @override
  set preco(String? value) {
    _$precoAtom.reportWrite(value, super.preco, () {
      super.preco = value;
    });
  }

  late final _$_precoApiErrorAtom =
      Atom(name: 'ProdutosEditControllerBase._precoApiError', context: context);

  @override
  String? get _precoApiError {
    _$_precoApiErrorAtom.reportRead();
    return super._precoApiError;
  }

  @override
  set _precoApiError(String? value) {
    _$_precoApiErrorAtom.reportWrite(value, super._precoApiError, () {
      super._precoApiError = value;
    });
  }

  late final _$unidadeMedidaAtom =
      Atom(name: 'ProdutosEditControllerBase.unidadeMedida', context: context);

  @override
  String? get unidadeMedida {
    _$unidadeMedidaAtom.reportRead();
    return super.unidadeMedida;
  }

  @override
  set unidadeMedida(String? value) {
    _$unidadeMedidaAtom.reportWrite(value, super.unidadeMedida, () {
      super.unidadeMedida = value;
    });
  }

  late final _$_unidadeMedidaApiErrorAtom = Atom(
      name: 'ProdutosEditControllerBase._unidadeMedidaApiError',
      context: context);

  @override
  String? get _unidadeMedidaApiError {
    _$_unidadeMedidaApiErrorAtom.reportRead();
    return super._unidadeMedidaApiError;
  }

  @override
  set _unidadeMedidaApiError(String? value) {
    _$_unidadeMedidaApiErrorAtom
        .reportWrite(value, super._unidadeMedidaApiError, () {
      super._unidadeMedidaApiError = value;
    });
  }

  late final _$codigoBarrasAtom =
      Atom(name: 'ProdutosEditControllerBase.codigoBarras', context: context);

  @override
  String? get codigoBarras {
    _$codigoBarrasAtom.reportRead();
    return super.codigoBarras;
  }

  @override
  set codigoBarras(String? value) {
    _$codigoBarrasAtom.reportWrite(value, super.codigoBarras, () {
      super.codigoBarras = value;
    });
  }

  late final _$_codigoBarrasApiErrorAtom = Atom(
      name: 'ProdutosEditControllerBase._codigoBarrasApiError',
      context: context);

  @override
  String? get _codigoBarrasApiError {
    _$_codigoBarrasApiErrorAtom.reportRead();
    return super._codigoBarrasApiError;
  }

  @override
  set _codigoBarrasApiError(String? value) {
    _$_codigoBarrasApiErrorAtom.reportWrite(value, super._codigoBarrasApiError,
        () {
      super._codigoBarrasApiError = value;
    });
  }

  late final _$estoqueAlvoAtom =
      Atom(name: 'ProdutosEditControllerBase.estoqueAlvo', context: context);

  @override
  String? get estoqueAlvo {
    _$estoqueAlvoAtom.reportRead();
    return super.estoqueAlvo;
  }

  @override
  set estoqueAlvo(String? value) {
    _$estoqueAlvoAtom.reportWrite(value, super.estoqueAlvo, () {
      super.estoqueAlvo = value;
    });
  }

  late final _$_estoqueAlvoApiErrorAtom = Atom(
      name: 'ProdutosEditControllerBase._estoqueAlvoApiError',
      context: context);

  @override
  String? get _estoqueAlvoApiError {
    _$_estoqueAlvoApiErrorAtom.reportRead();
    return super._estoqueAlvoApiError;
  }

  @override
  set _estoqueAlvoApiError(String? value) {
    _$_estoqueAlvoApiErrorAtom.reportWrite(value, super._estoqueAlvoApiError,
        () {
      super._estoqueAlvoApiError = value;
    });
  }

  late final _$estoqueAtom =
      Atom(name: 'ProdutosEditControllerBase.estoque', context: context);

  @override
  String? get estoque {
    _$estoqueAtom.reportRead();
    return super.estoque;
  }

  @override
  set estoque(String? value) {
    _$estoqueAtom.reportWrite(value, super.estoque, () {
      super.estoque = value;
    });
  }

  late final _$_estoqueApiErrorAtom = Atom(
      name: 'ProdutosEditControllerBase._estoqueApiError', context: context);

  @override
  String? get _estoqueApiError {
    _$_estoqueApiErrorAtom.reportRead();
    return super._estoqueApiError;
  }

  @override
  set _estoqueApiError(String? value) {
    _$_estoqueApiErrorAtom.reportWrite(value, super._estoqueApiError, () {
      super._estoqueApiError = value;
    });
  }

  late final _$isAtivoAtom =
      Atom(name: 'ProdutosEditControllerBase.isAtivo', context: context);

  @override
  bool get isAtivo {
    _$isAtivoAtom.reportRead();
    return super.isAtivo;
  }

  @override
  set isAtivo(bool value) {
    _$isAtivoAtom.reportWrite(value, super.isAtivo, () {
      super.isAtivo = value;
    });
  }

  late final _$isSavingAtom =
      Atom(name: 'ProdutosEditControllerBase.isSaving', context: context);

  @override
  bool get isSaving {
    _$isSavingAtom.reportRead();
    return super.isSaving;
  }

  @override
  set isSaving(bool value) {
    _$isSavingAtom.reportWrite(value, super.isSaving, () {
      super.isSaving = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'ProdutosEditControllerBase.isLoading', context: context);

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

  late final _$isPasswordVisibleAtom = Atom(
      name: 'ProdutosEditControllerBase.isPasswordVisible', context: context);

  @override
  bool get isPasswordVisible {
    _$isPasswordVisibleAtom.reportRead();
    return super.isPasswordVisible;
  }

  @override
  set isPasswordVisible(bool value) {
    _$isPasswordVisibleAtom.reportWrite(value, super.isPasswordVisible, () {
      super.isPasswordVisible = value;
    });
  }

  late final _$isConfirmPasswordVisibleAtom = Atom(
      name: 'ProdutosEditControllerBase.isConfirmPasswordVisible',
      context: context);

  @override
  bool get isConfirmPasswordVisible {
    _$isConfirmPasswordVisibleAtom.reportRead();
    return super.isConfirmPasswordVisible;
  }

  @override
  set isConfirmPasswordVisible(bool value) {
    _$isConfirmPasswordVisibleAtom
        .reportWrite(value, super.isConfirmPasswordVisible, () {
      super.isConfirmPasswordVisible = value;
    });
  }

  late final _$ProdutosEditControllerBaseActionController =
      ActionController(name: 'ProdutosEditControllerBase', context: context);

  @override
  void setImagePath(String v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setImagePath');
    try {
      return super.setImagePath(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNome(String? v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setNome');
    try {
      return super.setNome(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescricao(String? v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setDescricao');
    try {
      return super.setDescricao(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPreco(String? v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setPreco');
    try {
      return super.setPreco(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUnidadeMedida(String? v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setUnidadeMedida');
    try {
      return super.setUnidadeMedida(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCodigoBarras(String? v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setCodigoBarras');
    try {
      return super.setCodigoBarras(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEstoqueAlvo(String? v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setEstoqueAlvo');
    try {
      return super.setEstoqueAlvo(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEstoque(String? v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setEstoque');
    try {
      return super.setEstoque(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsAtivo(bool v) {
    final _$actionInfo = _$ProdutosEditControllerBaseActionController
        .startAction(name: 'ProdutosEditControllerBase.setIsAtivo');
    try {
      return super.setIsAtivo(v);
    } finally {
      _$ProdutosEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
imagePath: ${imagePath},
imageUrl: ${imageUrl},
nome: ${nome},
descricao: ${descricao},
preco: ${preco},
unidadeMedida: ${unidadeMedida},
codigoBarras: ${codigoBarras},
estoqueAlvo: ${estoqueAlvo},
estoque: ${estoque},
isAtivo: ${isAtivo},
isSaving: ${isSaving},
isLoading: ${isLoading},
isPasswordVisible: ${isPasswordVisible},
isConfirmPasswordVisible: ${isConfirmPasswordVisible},
getImageUrlError: ${getImageUrlError},
getNomeError: ${getNomeError},
getDescricaoError: ${getDescricaoError},
getPrecoError: ${getPrecoError},
getUnidadeMedidaError: ${getUnidadeMedidaError},
getCodigoBarrasError: ${getCodigoBarrasError},
getEstoqueAlvoError: ${getEstoqueAlvoError},
getEstoqueError: ${getEstoqueError},
isValid: ${isValid}
    ''';
  }
}
