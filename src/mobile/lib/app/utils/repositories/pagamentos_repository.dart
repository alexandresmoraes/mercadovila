import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamentos_dto.dart';
import 'package:vilasesmo/app/utils/models/pagamento/realizar_pagamento_model.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';
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
  Future<Either<ResultFailModel, RealizarPagamentoResponseModel>> realizarPagamento(RealizarPagamentoModel pagamentoModel) async {
    try {
      var response = await dio.post('/api/pagamentos', data: pagamentoModel.toJson());
      var result = RealizarPagamentoResponseModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<PagedResult<PagamentosDto>> getPagamentos(int page, String? username) async {
    var response = await dio.get('/api/pagamentos', queryParameters: {
      "page": page.toString(),
      "limit": 5,
      "username": username,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<Either<ResultFailModel, void>> cancelarPagamento(int pagamentoId) async {
    try {
      await dio.put('/api/pagamentos/cancelar/$pagamentoId');
      return const Right(null);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<PagedResult<PagamentosDto>> getMeusPagamentos(int page) async {
    var response = await dio.get('/api/pagamentos/meus-pagamentos', queryParameters: {
      "page": page.toString(),
      "limit": 5,
    });

    return PagedResult.fromJson(response.data);
  }
}
