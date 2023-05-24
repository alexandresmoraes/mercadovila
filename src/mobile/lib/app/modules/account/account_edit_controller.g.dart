// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_edit_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AccountEditController on _AccountEditControllerBase, Store {
  late final _$fotoBase64Atom =
      Atom(name: '_AccountEditControllerBase.fotoBase64', context: context);

  @override
  String? get fotoBase64 {
    _$fotoBase64Atom.reportRead();
    return super.fotoBase64;
  }

  @override
  set fotoBase64(String? value) {
    _$fotoBase64Atom.reportWrite(value, super.fotoBase64, () {
      super.fotoBase64 = value;
    });
  }

  late final _$fotoPathAtom =
      Atom(name: '_AccountEditControllerBase.fotoPath', context: context);

  @override
  String? get fotoPath {
    _$fotoPathAtom.reportRead();
    return super.fotoPath;
  }

  @override
  set fotoPath(String? value) {
    _$fotoPathAtom.reportWrite(value, super.fotoPath, () {
      super.fotoPath = value;
    });
  }

  late final _$_AccountEditControllerBaseActionController =
      ActionController(name: '_AccountEditControllerBase', context: context);

  @override
  void setFotoBase64(String? v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setFotoBase64');
    try {
      return super.setFotoBase64(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setfotoPath(String? v) {
    final _$actionInfo = _$_AccountEditControllerBaseActionController
        .startAction(name: '_AccountEditControllerBase.setfotoPath');
    try {
      return super.setfotoPath(v);
    } finally {
      _$_AccountEditControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fotoBase64: ${fotoBase64},
fotoPath: ${fotoPath}
    ''';
  }
}
