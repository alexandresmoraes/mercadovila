import 'package:dio/io.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/carrinho/carrinho_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_carrinho_repository.dart';

@Injectable()
class CarrinhoRepository implements ICarrinhoRepository {
  late final DioForNative dio;

  CarrinhoRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future adicionarCarrinho(String produtoId, int quantidade) async {
    await dio.post('/api/carrinho/$produtoId/$quantidade');
  }

  @override
  Future<CarrinhoDto> getCarrinho() async {
    var response = await dio.get('/api/carrinho');

    return CarrinhoDto.fromJson(response.data);
  }

  @override
  Future removerCarrinho(String produtoId, int quantidade) async {
    await dio.delete('/api/carrinho/$produtoId/$quantidade');
  }
}
