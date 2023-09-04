import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/produtos/produto_dto.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';
import 'package:vilasesmo/app/utils/models/produtos/produto_model.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';

abstract class IProdutosRepository implements Disposable {
  Future<ProdutoModel> getProduto(String id);
  Future<Either<ResultFailModel, ProdutoResponseModel>> createProduto(ProdutoModel produtoModel);
  Future<Either<ResultFailModel, String>> editProduto(String id, ProdutoModel produtoModel);
  Future<PagedResult<ProdutoDto>> getProdutos(int page, String? nome);
}
