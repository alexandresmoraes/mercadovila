// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_edit_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AccountEditController on _AccountEditControllerBase, Store {
  Computed<String?>? _$getNomeErrorComputed;

  @override
  String? get getNomeError =>
      (_$getNomeErrorComputed ??= Computed<String?>(() => super.getNomeError,
              name: '_AccountEditControllerBase.getNomeError'))
          .value;
  Computed<String?>? _$getUsernameErrorComputed;

  @override
  String? get getUsernameError => (_$getUsernameErrorComputed ??=
          Computed<String?>(() => super.getUsernameError,
              name: '_AccountEditControllerBase.getUsernameError'))
      .value;
  Computed<String?>? _$getEmailErrorComputed;

  @override
  String? get getEmailError =>
      (_$getEmailErrorComputed ??= Computed<String?>(() => super.getEmailError,
              name: '_AccountEditControllerBase.getEmailError'))
          .value;
  Computed<String?>? _$getPasswordErrorComputed;

  @override
  String? get getPasswordError => (_$getPasswordErrorComputed ??=
          Computed<String?>(() => super.getPasswordError,
              name: '_AccountEditControllerBase.getPasswordError'))
      .value;
  Computed<String?>? _$getConfirmPasswordErrorComputed;

  @override
  String? get getConfirmPasswordError => (_$getConfirmPasswordErrorComputed ??=
          Computed<String?>(() => super.getConfirmPasswordError,
              name: '_AccountEditControllerBase.getConfirmPasswordError'))
      .value;
  Computed<String?>? _$getTelefoneErrorComputed;

  @override
  String? get getTelefoneError => (_$getTelefoneErrorComputed ??=
          Computed<String?>(() => super.getTelefoneError,
              name: '_AccountEditControllerBase.getTelefoneError'))
      .value;

  late final _$photoPathAtom =
      Atom(name: '_AccountEditControllerBase.photoPath', context: context);

  @override
  String? get photoPath {
    _$photoPathAtom.reportRead();
    return super.photoPath;
  }

  @override
  set photoPath(String? value) {
    _$photoPathAtom.reportWrite(value, super.photoPath, () {
      super.photoPath = value;
    });
  }

  late final _$nomeAtom =
      Atom(name: '_AccountEditControllerBase.nome', context: context);

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
      Atom(name: '_AccountEditControllerBase._nomeApiError', context: context);

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

  late final _$usernameAtom =
      Atom(name: '_AccountEditControllerBase.username', context: context);

  @override
  String? get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String? value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  late final _$_usernameApiErrorAtom = Atom(
      name: '_AccountEditControllerBase._usernameApiError', context: context);

  @override
  String? get _usernameApiError {
    _$_usernameApiErrorAtom.reportRead();
    return super._usernameApiError;
  }

  @override
  set _usernameApiError(String? value) {
    _$_usernameApiErrorAtom.reportWrite(value, super._usernameApiError, () {
      super._usernameApiError = value;
    });
  }

  late final _$emailAtom =
      Atom(name: '_AccountEditControllerBase.email', context: context);

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$_emailApiErrorAtom =
      Atom(name: '_AccountEditControllerBase._emailApiError', context: context);

  @override
  String? get _emailApiError {
    _$_emailApiErrorAtom.reportRead();
    return super._emailApiError;
  }

  @override
  set _emailApiError(String? value) {
    _$_emailApiErrorAtom.reportWrite(value, super._emailApiError, () {
      super._emailApiError = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_AccountEditControllerBase.password', context: context);

  @override
  String? get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String? value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$_passwordApiErrorAtom = Atom(
      name: '_AccountEditControllerBase._passwordApiError', context: context);

  @override
  String? get _passwordApiError {
    _$_passwordApiErrorAtom.reportRead();
    return super._passwordApiError;
  }

  @override
  set _passwordApiError(String? value) {
    _$_passwordApiErrorAtom.reportWrite(value, super._passwordApiError, () {
      super._passwordApiError = value;
    });
  }

  late final _$confirmPasswordAtom = Atom(
      name: '_AccountEditControllerBase.confirmPassword', context: context);

  @override
  String? get confirmPassword {
    _$confirmPasswordAtom.reportRead();
    return super.confirmPassword;
  }

  @override
  set confirmPassword(String? value) {
    _$confirmPasswordAtom.reportWrite(value, super.confirmPassword, () {
      super.confirmPassword = value;
    });
  }

  late final _$_confirmPasswordApiErrorAtom = Atom(
      name: '_AccountEditControllerBase._confirmPasswordApiError',
      context: context);

  @override
  String? get _confirmPasswordApiError {
    _$_confirmPasswordApiErrorAtom.reportRead();
    return super._confirmPasswordApiError;
  }

  @override
  set _confirmPasswordApiError(String? value) {
    _$_confirmPasswordApiErrorAtom
        .reportWrite(value, super._confirmPasswordApiError, () {
      super._confirmPasswordApiError = value;
    });
  }

  late final _$telefoneAtom =
      Atom(name: '_AccountEditControllerBase.telefone', context: context);

  @override
  String? get telefone {
    _$telefoneAtom.reportRead();
    return super.telefone;
  }

  @override
  set telefone(String? value) {
    _$telefoneAtom.reportWrite(value, super.telefone, () {
      super.telefone = value;
    });
  }

  late final _$_telefoneApiErrorAtom = Atom(
      name: '_AccountEditControllerBase._telefoneApiError', context: context);

  @override
  String? get _telefoneApiError {
    _$_telefoneApiErrorAtom.reportRead();
    return super._telefoneApiError;
  }

  @override
  set _telefoneApiError(String? value) {
    _$_telefoneApiErrorAtom.reportWrite(value, super._telefoneApiError, () {
      super._telefoneApiError = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AccountEditControllerBase.isLoading', context: context);

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
      name: '_AccountEditControllerBase.isPasswordVisible', context: context);

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
      name: '_AccountEditControllerBase.isConfirmPasswordVisible',
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

  late final _$_AccountEditControllerBaseActionController =
      ActionController(name: '_AccountEditControllerBase', context: context);

  @override
  void setPhotoPath(String v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setPhotoPath');
    try {
      return super.setPhotoPath(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNome(String? v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setNome');
    try {
      return super.setNome(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUsername(String? v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setUsername');
    try {
      return super.setUsername(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String? v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setEmail');
    try {
      return super.setEmail(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String? v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setPassword');
    try {
      return super.setPassword(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmPassword(String? v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setConfirmPassword');
    try {
      return super.setConfirmPassword(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTelefone(String? v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setTelefone');
    try {
      return super.setTelefone(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
photoPath: ${photoPath},
nome: ${nome},
username: ${username},
email: ${email},
password: ${password},
confirmPassword: ${confirmPassword},
telefone: ${telefone},
isLoading: ${isLoading},
isPasswordVisible: ${isPasswordVisible},
isConfirmPasswordVisible: ${isConfirmPasswordVisible},
getNomeError: ${getNomeError},
getUsernameError: ${getUsernameError},
getEmailError: ${getEmailError},
getPasswordError: ${getPasswordError},
getConfirmPasswordError: ${getConfirmPasswordError},
getTelefoneError: ${getTelefoneError}
    ''';
  }
}
