import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';

abstract class ICatalogoRepository implements Disposable {
  Future<PagedResult<CatalogoDto>> getProdutosNovos(int page);
  Future<PagedResult<CatalogoDto>> getProdutosMaisVendidos(int page);
  Future<PagedResult<CatalogoDto>> getProdutosUltimosVendidos(int page);
  Future<PagedResult<CatalogoDto>> getProdutosFavoritos(int page);
}
