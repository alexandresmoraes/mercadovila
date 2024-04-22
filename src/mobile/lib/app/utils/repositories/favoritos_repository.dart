import 'package:dio/io.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/favoritos/favorito_item_dto.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_favoritos_repository.dart';

@Injectable()
class FavoritosRepository implements IFavoritosRepository {
  late final DioForNative dio;

  FavoritosRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future adicionarFavorito(String produtoId) async {
    await dio.post('/api/favoritos/$produtoId');
  }

  @override
  Future removerFavorito(String produtoId) async {
    await dio.delete('/api/favoritos/$produtoId');
  }

  @override
  Future<PagedResult<FavoritoItemDto>> getFavoritos(int page) async {
    var response = await dio.get('/api/favoritos', queryParameters: {
      "page": page.toString(),
      "limit": 10,
    });

    return PagedResult.fromJson(response.data);
  }
}
