import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/models/pagamento/realizar_pagamento_model.dart';
import 'package:vilasesmo/app/utils/models/produtos/produto_model.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';
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

  @override
  Future<Either<ResultFailModel, RealizarPagamentoResponseModel>> realizarPagamento(
      RealizarPagamentoModel pagamentoModel) async {
    try {
      var response = await dio.post('/api/pagamentos', data: pagamentoModel.toJson());
      var result = RealizarPagamentoResponseModel.fromJson(response.data);
      return Right(result);
    } on DioError catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }
}
