import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';
import 'package:vilasesmo/app/utils/models/vendas/venda_model.dart';

abstract class IVendasRepository implements Disposable {
  Future<Either<ResultFailModel, VendaResponseModel>> createVenda(VendaModel vendaModel);
}
