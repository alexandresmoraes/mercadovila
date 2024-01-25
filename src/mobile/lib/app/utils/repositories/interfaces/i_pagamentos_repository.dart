import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamento_detalhe_dto.dart';
import 'package:vilasesmo/app/utils/models/produtos/produto_model.dart';

abstract class IPagamentosRepository implements Disposable {
  Future<PagamentoDetalheDto> getPagamentoDetalheMe();
  Future<PagamentoDetalheDto> getPagamentoDetalhePorUsuario(String userId);
  // Future<Either<ResultFailModel, ProdutoResponseModel>> createPagamento(Pagame produtoModel);
}
