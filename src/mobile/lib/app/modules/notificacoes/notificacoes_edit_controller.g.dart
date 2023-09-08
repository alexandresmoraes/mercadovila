// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacoes_edit_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificacoesEditController on NotificacoesEditControllerBase, Store {
  Computed<String?>? _$getTituloErrorComputed;

  @override
  String? get getTituloError => (_$getTituloErrorComputed ??= Computed<String?>(
          () => super.getTituloError,
          name: 'NotificacoesEditControllerBase.getTituloError'))
      .value;
  Computed<String?>? _$getMensagemErrorComputed;

  @override
  String? get getMensagemError => (_$getMensagemErrorComputed ??=
          Computed<String?>(() => super.getMensagemError,
              name: 'NotificacoesEditControllerBase.getMensagemError'))
      .value;
  Computed<bool>? _$isValidComputed;

  @override
  bool get isValid => (_$isValidComputed ??= Computed<bool>(() => super.isValid,
          name: 'NotificacoesEditControllerBase.isValid'))
      .value;

  late final _$imagePathAtom =
      Atom(name: 'NotificacoesEditControllerBase.imagePath', context: context);

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
      Atom(name: 'NotificacoesEditControllerBase.imageUrl', context: context);

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

  late final _$tituloAtom =
      Atom(name: 'NotificacoesEditControllerBase.titulo', context: context);

  @override
  String? get titulo {
    _$tituloAtom.reportRead();
    return super.titulo;
  }

  @override
  set titulo(String? value) {
    _$tituloAtom.reportWrite(value, super.titulo, () {
      super.titulo = value;
    });
  }

  late final _$_tituloApiErrorAtom = Atom(
      name: 'NotificacoesEditControllerBase._tituloApiError', context: context);

  @override
  String? get _tituloApiError {
    _$_tituloApiErrorAtom.reportRead();
    return super._tituloApiError;
  }

  @override
  set _tituloApiError(String? value) {
    _$_tituloApiErrorAtom.reportWrite(value, super._tituloApiError, () {
      super._tituloApiError = value;
    });
  }

  late final _$mensagemAtom =
      Atom(name: 'NotificacoesEditControllerBase.mensagem', context: context);

  @override
  String? get mensagem {
    _$mensagemAtom.reportRead();
    return super.mensagem;
  }

  @override
  set mensagem(String? value) {
    _$mensagemAtom.reportWrite(value, super.mensagem, () {
      super.mensagem = value;
    });
  }

  late final _$_mensagemApiErrorAtom = Atom(
      name: 'NotificacoesEditControllerBase._mensagemApiError',
      context: context);

  @override
  String? get _mensagemApiError {
    _$_mensagemApiErrorAtom.reportRead();
    return super._mensagemApiError;
  }

  @override
  set _mensagemApiError(String? value) {
    _$_mensagemApiErrorAtom.reportWrite(value, super._mensagemApiError, () {
      super._mensagemApiError = value;
    });
  }

  late final _$isSavingAtom =
      Atom(name: 'NotificacoesEditControllerBase.isSaving', context: context);

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

  late final _$isDeletingAtom =
      Atom(name: 'NotificacoesEditControllerBase.isDeleting', context: context);

  @override
  bool get isDeleting {
    _$isDeletingAtom.reportRead();
    return super.isDeleting;
  }

  @override
  set isDeleting(bool value) {
    _$isDeletingAtom.reportWrite(value, super.isDeleting, () {
      super.isDeleting = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'NotificacoesEditControllerBase.isLoading', context: context);

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

  late final _$NotificacoesEditControllerBaseActionController =
      ActionController(
          name: 'NotificacoesEditControllerBase', context: context);

  @override
  void setImagePath(String v) {
    final _$actionInfo = _$NotificacoesEditControllerBaseActionController
        .startAction(name: 'NotificacoesEditControllerBase.setImagePath');
    try {
      return super.setImagePath(v);
    } finally {
      _$NotificacoesEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTitulo(String? v) {
    final _$actionInfo = _$NotificacoesEditControllerBaseActionController
        .startAction(name: 'NotificacoesEditControllerBase.setTitulo');
    try {
      return super.setTitulo(v);
    } finally {
      _$NotificacoesEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMensagem(String? v) {
    final _$actionInfo = _$NotificacoesEditControllerBaseActionController
        .startAction(name: 'NotificacoesEditControllerBase.setMensagem');
    try {
      return super.setMensagem(v);
    } finally {
      _$NotificacoesEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
imagePath: ${imagePath},
imageUrl: ${imageUrl},
titulo: ${titulo},
mensagem: ${mensagem},
isSaving: ${isSaving},
isDeleting: ${isDeleting},
isLoading: ${isLoading},
getTituloError: ${getTituloError},
getMensagemError: ${getMensagemError},
isValid: ${isValid}
    ''';
  }
}
