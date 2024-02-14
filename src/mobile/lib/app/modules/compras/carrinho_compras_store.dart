import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/compras/carrinho_compras_dto.dart';

part 'carrinho_compras_store.g.dart';

class CarrinhoComprasStore = CarrinhoComprasStoreBase with _$CarrinhoComprasStore;

abstract class CarrinhoComprasStoreBase with Store {
  @observable
  ObservableList<CarrinhoComprasItemDto> carrinhoComprasItens = ObservableList<CarrinhoComprasItemDto>();

  @observable
  CarrinhoComprasDto? carrinhoComprasDto = CarrinhoComprasDto(
    itens: [
      CarrinhoComprasItemDto(
        produtoId: "produtoId",
        nome: "nome",
        descricao: "descricao",
        imageUrl: "imageUrl",
        preco: 5.40,
        unidadeMedida: "un",
        estoque: 7,
        rating: 5,
        ratingCount: 150,
        isAtivo: true,
        quantidade: 5,
        isPrecoMedioSugerido: true,
      )
    ],
    subtotal: 0,
    total: 0,
  );

  @observable
  bool isLoading = false;

  @action
  Future<CarrinhoComprasDto> load() async {
    try {
      isLoading = true;

      carrinhoComprasItens = ObservableList.of(carrinhoComprasDto!.itens);

      return carrinhoComprasDto!;
    } finally {
      isLoading = false;
    }
  }
}
