import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/produtos/produto_dto.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';
import 'package:vilasesmo/app/utils/models/produtos/produto_model.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_produtos_repository.dart';

@Injectable()
class ProdutosRepository implements IProdutosRepository {
  late final DioForNative dio;

  ProdutosRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<Either<ResultFailModel, ProdutoResponseModel>> createProduto(ProdutoModel produtoModel) async {
    try {
      var response = await dio.post('/api/produtos', data: produtoModel.toJson());
      var result = ProdutoResponseModel.fromJson(response.data);
      return Right(result);
    } on DioError catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<Either<ResultFailModel, String>> editProduto(String id, ProdutoModel produtoModel) async {
    try {
      await dio.put('/api/produtos/$id', data: produtoModel.toJson());
      return Right(id);
    } on DioError catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<ProdutoModel> getProduto(String id) async {
    var response = await dio.get('/api/produtos/$id');

    return ProdutoModel.fromJson(response.data);
  }

  @override
  Future<PagedResult<ProdutoDto>> getProdutos(int page, String? nome) async {
    var response = await dio.get('/api/produtos', queryParameters: {
      "page": page.toString(),
      "limit": 10,
      "nome": nome,
    });

    return PagedResult.fromJson(response.data);
  }
}
