import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/carrinho/carrinho_dto.dart';

abstract class ICarrinhoRepository implements Disposable {
  Future adicionarCarrinho(String produtoId, int quantidade);
  Future removerCarrinho(String produtoId, int quantidade);
  Future<CarrinhoDto> getCarrinho();
}
