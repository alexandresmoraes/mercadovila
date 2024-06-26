import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/produtos/lista_compras_dto.dart';
import 'package:mercadovila/app/utils/dto/produtos/produto_detail_dto.dart';
import 'package:mercadovila/app/utils/dto/produtos/produto_dto.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/models/produtos/image_upload_response_model.dart';
import 'package:mercadovila/app/utils/models/produtos/produto_model.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';

abstract class IProdutosRepository implements Disposable {
  Future<ProdutoModel> getProduto(String id);
  Future<Either<ResultFailModel, ProdutoResponseModel>> createProduto(ProdutoModel produtoModel);
  Future<Either<ResultFailModel, String>> editProduto(String id, ProdutoModel produtoModel);
  Future<PagedResult<ProdutoDto>> getProdutos(int page, String? nome);
  Future<Either<ResultFailModel, ImageUploadResponseModel>> uploadImageProdutos(String filepath, String? mimeType, String? filenameWeb);
  Future<ProdutoDetailDto> getProdutoDetail(String id);
  Future<PagedResult<ListaComprasDto>> getListaCompra(int page);
  Future<Either<void, ProdutoDto>> getProdutoPorCodigoBarra(String codigoBarra);
}
