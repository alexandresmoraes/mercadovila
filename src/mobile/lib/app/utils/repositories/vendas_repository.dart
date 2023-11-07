import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';
import 'package:vilasesmo/app/utils/models/vendas/venda_model.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_vendas_repository.dart';

@Injectable()
class VendasRepository implements IVendasRepository {
  late final DioForNative dio;

  VendasRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<Either<ResultFailModel, VendaResponseModel>> createVenda(VendaModel vendaModel) async {
    try {
      var response = await dio.post('/api/vendas', data: vendaModel.toJson());
      var result = VendaResponseModel.fromJson(response.data);
      return Right(result);
    } on DioError catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }
}
