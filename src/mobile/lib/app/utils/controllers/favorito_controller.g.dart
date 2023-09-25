// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorito_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FavoritoController on FavoritoControllerBase, Store {
  late final _$isFavoritoAtom =
      Atom(name: 'FavoritoControllerBase.isFavorito', context: context);

  @override
  bool get isFavorito {
    _$isFavoritoAtom.reportRead();
    return super.isFavorito;
  }

  @override
  set isFavorito(bool value) {
    _$isFavoritoAtom.reportWrite(value, super.isFavorito, () {
      super.isFavorito = value;
    });
  }

  @override
  String toString() {
    return '''
isFavorito: ${isFavorito}
    ''';
  }
}
