import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/compras/compra_dto.dart';
import 'package:mercadovila/app/utils/models/compras/compra_model.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_compras_repository.dart';

@Injectable()
class ComprasRepository implements IComprasRepository {
  late final DioForNative dio;

  ComprasRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<Either<ResultFailModel, CompraResponseModel>> criarCompra(CompraModel compraModel) async {
    try {
      var response = await dio.post('/api/compras', data: compraModel.toJson());
      var result = CompraResponseModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<CompraDetalheDto> getCompra(int id) async {
    var response = await dio.get('/api/compras/$id');

    return CompraDetalheDto.fromJson(response.data);
  }

  @override
  Future<PagedResult<CompraDto>> getCompras(int page, DateTime? dataInicial, DateTime? dataFinal) async {
    var response = await dio.get('/api/compras', queryParameters: {
      "page": page,
      "limit": 10,
      "dataInicial": dataInicial,
      "dataFinal": dataFinal,
    });

    return PagedResult.fromJson(response.data);
  }
}
