import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:vilasesmo/app/utils/dto/compras/carrinho_compras_dto.dart';
import 'package:vilasesmo/app/utils/dto/produtos/produto_dto.dart';
import 'package:vilasesmo/app/utils/models/compras/compra_model.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_compras_repository.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

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
    update();
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
        precoPago: selectedItem!.preco,
        unidadeMedida: selectedItem!.unidadeMedida,
        codigoBarras: selectedItem!.codigoBarras,
        estoque: selectedItem!.estoque,
        rating: selectedItem!.ratingCount,
        ratingCount: selectedItem!.ratingCount,
        isAtivo: selectedItem!.isAtivo,
        precoSugerido: selectedItem!.preco,
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
        update();
        return true;
      }
    }
    return false;
  }

  @action
  bool removerCarrinhoComprasItem(String produtoId, bool removeAll) {
    int removeIndex = -1;

    for (int i = 0; i < carrinhoComprasItens.length; i++) {
      if (carrinhoComprasItens[i].produtoId == produtoId) {
        if (carrinhoComprasItens[i].quantidade > 1 && !removeAll) {
          carrinhoComprasItens[i].quantidade--;
          update();
          return true;
        } else {
          removeIndex = i;
          break;
        }
      }
    }

    if (removeIndex != -1) {
      carrinhoComprasItens.removeAt(removeIndex);
      update();
      return true;
    }

    return false;
  }

  @action
  void update() {
    subTotal = carrinhoComprasItens.fold(0, (previousValue, item) => previousValue + (item.precoPago * item.quantidade));
    total = carrinhoComprasItens.fold(0, (previousValue, item) => previousValue + (item.precoPago * item.quantidade));
  }

  @observable
  bool isLoading = false;

  @computed
  bool get isValidCarrinhoCompras => carrinhoComprasItens.isNotEmpty;

  @observable
  double subTotal = 0;

  @observable
  double total = 0;

  void clearCarrinhoCompras() {
    carrinhoComprasItens.clear();
    total = 0;
    subTotal = 0;
  }

  Future<void> criarCompra() async {
    try {
      isLoading = true;

      var compraRepository = Modular.get<IComprasRepository>();

      var compraItens = carrinhoComprasItens
          .map(
            (e) => CompraItemModel(
              produtoId: e.produtoId,
              nome: e.nome,
              imageUrl: e.imageUrl,
              descricao: e.descricao,
              estoqueAtual: e.estoque,
              precoPago: e.precoPago,
              precoSugerido: e.precoSugerido,
              isPrecoMedioSugerido: e.isPrecoMedioSugerido,
              quantidade: e.quantidade,
              unidadeMedida: e.unidadeMedida,
            ),
          )
          .toList();

      var compraModel = CompraModel(
        usuarioNome: Modular.get<AccountStore>().account!.nome,
        usuarioFotoUrl: Modular.get<AccountStore>().account!.fotoUrl,
        compraItens: compraItens,
      );

      var result = await compraRepository.criarCompra(compraModel);

      await result.fold((fail) {
        var message = fail.getErrorNotProperty();
        if (message.isNotEmpty) GlobalSnackbar.error(message);
      }, (accountResponse) async {
        GlobalSnackbar.success('Compra criada com sucesso!');
        Modular.to.pop(true);
        clearCarrinhoCompras();
      });
    } finally {
      isLoading = false;
    }
  }
}
