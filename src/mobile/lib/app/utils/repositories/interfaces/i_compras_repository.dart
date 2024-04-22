import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/compras/compra_dto.dart';
import 'package:mercadovila/app/utils/models/compras/compra_model.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';

abstract class IComprasRepository implements Disposable {
  Future<Either<ResultFailModel, CompraResponseModel>> criarCompra(CompraModel compraModel);
  Future<PagedResult<CompraDto>> getCompras(int page, DateTime? dataInicial, DateTime? dataFinal);
  Future<CompraDetalheDto> getCompra(int id);
}
