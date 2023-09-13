// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produtos_detail_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProdutosDetailController on ProdutosDetailControllerBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'ProdutosDetailControllerBase.isLoading', context: context);

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

  late final _$isFavoritoAtom =
      Atom(name: 'ProdutosDetailControllerBase.isFavorito', context: context);

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

  late final _$isVisibleFavoritosAtom = Atom(
      name: 'ProdutosDetailControllerBase.isVisibleFavoritos',
      context: context);

  @override
  bool get isVisibleFavoritos {
    _$isVisibleFavoritosAtom.reportRead();
    return super.isVisibleFavoritos;
  }

  @override
  set isVisibleFavoritos(bool value) {
    _$isVisibleFavoritosAtom.reportWrite(value, super.isVisibleFavoritos, () {
      super.isVisibleFavoritos = value;
    });
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isFavorito: ${isFavorito},
isVisibleFavoritos: ${isVisibleFavoritos}
    ''';
  }
}
