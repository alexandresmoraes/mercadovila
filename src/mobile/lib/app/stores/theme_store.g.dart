// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemeStore on _ThemeStoreBase, Store {
  late final _$isDarkModeEnableAtom =
      Atom(name: '_ThemeStoreBase.isDarkModeEnable', context: context);

  @override
  bool get isDarkModeEnable {
    _$isDarkModeEnableAtom.reportRead();
    return super.isDarkModeEnable;
  }

  @override
  set isDarkModeEnable(bool value) {
    _$isDarkModeEnableAtom.reportWrite(value, super.isDarkModeEnable, () {
      super.isDarkModeEnable = value;
    });
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_ThemeStoreBase.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool isDarkModeEnable) {
    return _$setDarkModeAsyncAction
        .run(() => super.setDarkMode(isDarkModeEnable));
  }

  @override
  String toString() {
    return '''
isDarkModeEnable: ${isDarkModeEnable}
    ''';
  }
}
