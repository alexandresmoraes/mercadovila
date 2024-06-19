import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/vendas/venda_dto.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';
import 'package:mercadovila/app/utils/models/vendas/venda_model.dart';

abstract class IVendasRepository implements Disposable {
  Future<Either<ResultFailModel, VendaResponseModel>> criarVenda(VendaModel vendaModel);
  Future<PagedResult<VendaDto>> getVendas(int page, DateTime? dataInicial, DateTime? dataFinal, String? compradorNome);
  Future<PagedResult<VendaDto>> getMinhasCompras(int page, DateTime? dataInicial, DateTime? dataFinal);
  Future<VendaDetalheDto> getVenda(int id);
  Future<Either<ResultFailModel, void>> cancelarVenda(int vendaId);
}
