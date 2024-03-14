// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginController on LoginControllerBase, Store {
  Computed<String?>? _$getNomeErrorComputed;

  @override
  String? get getNomeError =>
      (_$getNomeErrorComputed ??= Computed<String?>(() => super.getNomeError,
              name: 'LoginControllerBase.getNomeError'))
          .value;
  Computed<String?>? _$getPasswordErrorComputed;

  @override
  String? get getPasswordError => (_$getPasswordErrorComputed ??=
          Computed<String?>(() => super.getPasswordError,
              name: 'LoginControllerBase.getPasswordError'))
      .value;

  late final _$usernameAtom =
      Atom(name: 'LoginControllerBase.username', context: context);

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

  late final _$_usernameApiErrorAtom =
      Atom(name: 'LoginControllerBase._usernameApiError', context: context);

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

  late final _$passwordAtom =
      Atom(name: 'LoginControllerBase.password', context: context);

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

  late final _$_passwordApiErrorAtom =
      Atom(name: 'LoginControllerBase._passwordApiError', context: context);

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

  late final _$isPasswordVisibleAtom =
      Atom(name: 'LoginControllerBase.isPasswordVisible', context: context);

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

  late final _$LoginControllerBaseActionController =
      ActionController(name: 'LoginControllerBase', context: context);

  @override
  void setUsername(String? v) {
    final _$actionInfo = _$LoginControllerBaseActionController.startAction(
        name: 'LoginControllerBase.setUsername');
    try {
      return super.setUsername(v);
    } finally {
      _$LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String? v) {
    final _$actionInfo = _$LoginControllerBaseActionController.startAction(
        name: 'LoginControllerBase.setPassword');
    try {
      return super.setPassword(v);
    } finally {
      _$LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
username: ${username},
password: ${password},
isPasswordVisible: ${isPasswordVisible},
getNomeError: ${getNomeError},
getPasswordError: ${getPasswordError}
    ''';
  }
}
