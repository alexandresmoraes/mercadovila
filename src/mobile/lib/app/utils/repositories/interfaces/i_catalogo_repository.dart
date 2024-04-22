import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/queries/catalogo_todos_query.dart';

abstract class ICatalogoRepository implements Disposable {
  Future<PagedResult<CatalogoDto>> getProdutosNovos(int page);
  Future<PagedResult<CatalogoDto>> getProdutosMaisVendidos(int page);
  Future<PagedResult<CatalogoDto>> getProdutosUltimosVendidos(int page);
  Future<PagedResult<CatalogoDto>> getProdutosFavoritos(int page);
  Future<PagedResult<CatalogoDto>> getProdutosTodos(CatalogoTodosQuery query);
}
