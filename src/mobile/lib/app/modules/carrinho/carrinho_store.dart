import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/carrinho/carrinho_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_carrinho_repository.dart';

part 'carrinho_store.g.dart';

class CarrinhoStore = CarrinhoStoreBase with _$CarrinhoStore;

abstract class CarrinhoStoreBase with Store {
  @observable
  bool isFormaPagamentoSelected = false;

  @observable
  bool selectOpcaoPagamento = false;

  @action
  void setSelectOpcaoPagamento(bool value) {
    selectOpcaoPagamento = value;
  }

  @observable
  ObservableList<CarrinhoItemDto> carrinhoItens = ObservableList<CarrinhoItemDto>();

  @observable
  CarrinhoDto? carrinhoDto;

  @observable
  bool isLoading = false;

  @action
  Future<CarrinhoDto> load() async {
    try {
      isLoading = true;

      var carrinhoRepository = Modular.get<ICarrinhoRepository>();

      carrinhoDto = await carrinhoRepository.getCarrinho();
      carrinhoItens = ObservableList.of(carrinhoDto!.itens);

      return carrinhoDto!;
    } finally {
      isLoading = false;
    }
  }
}
