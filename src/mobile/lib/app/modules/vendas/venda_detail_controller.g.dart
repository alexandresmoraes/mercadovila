// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venda_detail_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VendaDetailController on VendaDetailControllerBase, Store {
  late final _$vendaDetailDtoAtom =
      Atom(name: 'VendaDetailControllerBase.vendaDetailDto', context: context);

  @override
  VendaDetalheDto? get vendaDetailDto {
    _$vendaDetailDtoAtom.reportRead();
    return super.vendaDetailDto;
  }

  @override
  set vendaDetailDto(VendaDetalheDto? value) {
    _$vendaDetailDtoAtom.reportWrite(value, super.vendaDetailDto, () {
      super.vendaDetailDto = value;
    });
  }

  late final _$isLoadingCancelarAtom = Atom(
      name: 'VendaDetailControllerBase.isLoadingCancelar', context: context);

  @override
  bool get isLoadingCancelar {
    _$isLoadingCancelarAtom.reportRead();
    return super.isLoadingCancelar;
  }

  @override
  set isLoadingCancelar(bool value) {
    _$isLoadingCancelarAtom.reportWrite(value, super.isLoadingCancelar, () {
      super.isLoadingCancelar = value;
    });
  }

  @override
  String toString() {
    return '''
vendaDetailDto: ${vendaDetailDto},
isLoadingCancelar: ${isLoadingCancelar}
    ''';
  }
}
