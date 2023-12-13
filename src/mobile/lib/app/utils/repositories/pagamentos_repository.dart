import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_pagamentos_repository.dart';

@Injectable()
class PagamentosRepository implements IPagamentosRepository {
  late final DioForNative dio;

  PagamentosRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<PagamentoDetalheDto> getPagamentoDetalheMe() async {
    var response = await dio.get('/api/pagamentos/me');

    return PagamentoDetalheDto.fromJson(response.data);
  }

  @override
  Future<PagamentoDetalheDto> getPagamentoDetalhePorUsuario(String userId) async {
    var response = await dio.get('/api/pagamentos/$userId');

    return PagamentoDetalheDto.fromJson(response.data);
  }
}
