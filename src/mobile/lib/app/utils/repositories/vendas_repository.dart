import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/vendas/venda_dto.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';
import 'package:mercadovila/app/utils/models/vendas/venda_model.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_vendas_repository.dart';

@Injectable()
class VendasRepository implements IVendasRepository {
  late final DioForNative dio;

  VendasRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<Either<ResultFailModel, VendaResponseModel>> criarVenda(VendaModel vendaModel) async {
    try {
      var response = await dio.post('/api/vendas', data: vendaModel.toJson());
      var result = VendaResponseModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<PagedResult<VendaDto>> getVendas(int page, DateTime? dataInicial, DateTime? dataFinal) async {
    var response = await dio.get('/api/vendas', queryParameters: {
      "page": page,
      "limit": 10,
      "dataInicial": dataInicial,
      "dataFinal": dataFinal,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<PagedResult<VendaDto>> getMinhasCompras(int page, DateTime? dataInicial, DateTime? dataFinal) async {
    var response = await dio.get('/api/vendas/minhas-compras', queryParameters: {
      "page": page,
      "limit": 10,
      "dataInicial": dataInicial,
      "dataFinal": dataFinal,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<VendaDetalheDto> getVenda(int id) async {
    var response = await dio.get('/api/vendas/$id');

    return VendaDetalheDto.fromJson(response.data);
  }

  @override
  Future<Either<ResultFailModel, void>> cancelarVenda(int vendaId) async {
    try {
      await dio.put('/api/vendas/cancelar/$vendaId');
      return const Right(null);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }
}
