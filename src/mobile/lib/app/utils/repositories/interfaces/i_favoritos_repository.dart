import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/favoritos/favorito_item_dto.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';

abstract class IFavoritosRepository implements Disposable {
  Future adicionarFavorito(String produtoId);
  Future removerFavorito(String produtoId);
  Future<PagedResult<FavoritoItemDto>> getFavoritos(int page);
}
