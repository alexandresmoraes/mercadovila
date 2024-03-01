import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/compras/carrinho_compras_dto.dart';
import 'package:vilasesmo/app/utils/dto/produtos/produto_dto.dart';

part 'carrinho_compras_store.g.dart';

class CarrinhoComprasStore = CarrinhoComprasStoreBase with _$CarrinhoComprasStore;

abstract class CarrinhoComprasStoreBase with Store {
  TextEditingController produtoItemController = TextEditingController();

  @observable
  ObservableList<CarrinhoComprasItemDto> carrinhoComprasItens = ObservableList<CarrinhoComprasItemDto>();

  @observable
  ProdutoDto? selectedItem;

  @computed
  bool get isSelectedItem => selectedItem != null;

  @action
  void clearSelectedItem() {
    selectedItem = null;
    produtoItemController.text = "";
  }

  @action
  void setSelectItem(ProdutoDto item) {
    selectedItem = item;
  }

  @action
  void addCarrinhoComprasItem() {
    if (!addCarrinhoComprasItemExistente(selectedItem!.id)) {
      carrinhoComprasItens.add(CarrinhoComprasItemDto(
        produtoId: selectedItem!.id,
        nome: selectedItem!.nome,
        descricao: selectedItem!.descricao,
        imageUrl: selectedItem!.imageUrl,
        preco: selectedItem!.preco,
        unidadeMedida: selectedItem!.unidadeMedida,
        codigoBarras: selectedItem!.codigoBarras,
        estoque: selectedItem!.estoque,
        rating: selectedItem!.ratingCount,
        ratingCount: selectedItem!.ratingCount,
        isAtivo: selectedItem!.isAtivo,
        quantidade: 1,
        isPrecoMedioSugerido: true,
      ));
    }

    clearSelectedItem();
  }

  @action
  bool addCarrinhoComprasItemExistente(String produtoId) {
    for (int i = 0; i < carrinhoComprasItens.length; i++) {
      if (carrinhoComprasItens[i].produtoId == produtoId) {
        carrinhoComprasItens[i].quantidade++;
        return true;
      }
    }
    return false;
  }

  @action
  bool removerCarrinhoComprasItem(String produtoId) {
    int removeIndex = -1;

    for (int i = 0; i < carrinhoComprasItens.length; i++) {
      if (carrinhoComprasItens[i].produtoId == produtoId) {
        if (carrinhoComprasItens[i].quantidade > 1) {
          carrinhoComprasItens[i].quantidade--;
          return true;
        } else {
          removeIndex = i;
          break;
        }
      }
    }

    if (removeIndex != -1) {
      carrinhoComprasItens.removeAt(removeIndex);
      return true;
    }

    return false;
  }

  @observable
  bool isLoading = false;

  @computed
  bool get isValidCarrinhoCompras => carrinhoComprasItens.isNotEmpty;

  @computed
  num get subtotal => carrinhoComprasItens.fold(0, (previousValue, item) => previousValue + (item.preco * item.quantidade));

  @computed
  num get total => carrinhoComprasItens.fold(0, (previousValue, item) => previousValue + item.preco);
}
