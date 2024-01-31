import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamentos_dto.dart';
import 'package:vilasesmo/app/utils/models/pagamento/realizar_pagamento_model.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';

abstract class IPagamentosRepository implements Disposable {
  Future<PagamentoDetalheDto> getPagamentoDetalheMe();
  Future<PagamentoDetalheDto> getPagamentoDetalhePorUsuario(String userId);
  Future<Either<ResultFailModel, RealizarPagamentoResponseModel>> realizarPagamento(RealizarPagamentoModel pagamentoModel);
  Future<PagedResult<PagamentosDto>> getPagamentos(int page, String? username);
}
