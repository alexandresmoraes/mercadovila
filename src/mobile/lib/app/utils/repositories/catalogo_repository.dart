import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';
import 'package:vilasesmo/app/utils/queries/catalogo_todos_query.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_catalogo_repository.dart';

@Injectable()
class CatalogoRepository implements ICatalogoRepository {
  late final DioForNative dio;

  CatalogoRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<PagedResult<CatalogoDto>> getProdutosMaisVendidos(int page) async {
    var response = await dio.get('/api/catalogo/mais-vendidos', queryParameters: {
      "page": page.toString(),
      "limit": 10,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<PagedResult<CatalogoDto>> getProdutosNovos(int page) async {
    var response = await dio.get('/api/catalogo/novos', queryParameters: {
      "page": page.toString(),
      "limit": 10,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<PagedResult<CatalogoDto>> getProdutosUltimosVendidos(int page) async {
    var response = await dio.get('/api/catalogo/ultimos-vendidos', queryParameters: {
      "page": page.toString(),
      "limit": 10,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<PagedResult<CatalogoDto>> getProdutosFavoritos(int page) async {
    var response = await dio.get('/api/catalogo/favoritos', queryParameters: {
      "page": page.toString(),
      "limit": 10,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<PagedResult<CatalogoDto>> getProdutosTodos(CatalogoTodosQuery query) async {
    var response = await dio.get('/api/catalogo/todos', queryParameters: query.toMap());

    return PagedResult.fromJson(response.data);
  }
}
