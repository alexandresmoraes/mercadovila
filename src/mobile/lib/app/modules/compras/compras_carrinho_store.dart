import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mercadovila/app/stores/account_store.dart';
import 'package:mercadovila/app/utils/dto/compras/carrinho_compras_dto.dart';
import 'package:mercadovila/app/utils/dto/produtos/produto_dto.dart';
import 'package:mercadovila/app/utils/models/compras/compra_model.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_compras_repository.dart';
import 'package:mercadovila/app/utils/widgets/global_snackbar.dart';

part 'compras_carrinho_store.g.dart';

class ComprasCarrinhoStore = ComprasCarrinhoStoreBase with _$ComprasCarrinhoStore;

abstract class ComprasCarrinhoStoreBase with Store {
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
    produtoItemController.clear();
  }

  @action
  void setSelectItem(ProdutoDto item) {
    selectedItem = item;
  }

  @action
  CarrinhoComprasItemDto addCarrinhoComprasItem() {
    var carrinhoItem = addCarrinhoComprasItemExistente(selectedItem!.id);

    if (carrinhoItem == null) {
      carrinhoItem = CarrinhoComprasItemDto(
        produtoId: selectedItem!.id,
        nome: selectedItem!.nome,
        descricao: selectedItem!.descricao,
        imageUrl: selectedItem!.imageUrl,
        preco: selectedItem!.preco.toDouble(),
        precoPago: selectedItem!.preco.toDouble(),
        unidadeMedida: selectedItem!.unidadeMedida,
        codigoBarras: selectedItem!.codigoBarras,
        estoque: selectedItem!.estoque,
        rating: selectedItem!.ratingCount,
        ratingCount: selectedItem!.ratingCount,
        isAtivo: selectedItem!.isAtivo,
        precoSugerido: selectedItem!.preco.toDouble(),
        quantidade: 1,
        isPrecoMedioSugerido: true,
      );
      carrinhoComprasItens.add(carrinhoItem);
    }

    clearSelectedItem();
    refresh();

    return carrinhoItem;
  }

  @action
  void refresh() {
    carrinhoComprasItens = ObservableList<CarrinhoComprasItemDto>.of(carrinhoComprasItens);
  }

  @action
  CarrinhoComprasItemDto? addCarrinhoComprasItemExistente(String produtoId) {
    for (int i = 0; i < carrinhoComprasItens.length; i++) {
      if (carrinhoComprasItens[i].produtoId == produtoId) {
        carrinhoComprasItens[i].quantidade++;
        return carrinhoComprasItens[i];
      }
    }
    return null;
  }

  @action
  bool removerCarrinhoComprasItem(String produtoId, bool removeAll) {
    int removeIndex = -1;

    for (int i = 0; i < carrinhoComprasItens.length; i++) {
      if (carrinhoComprasItens[i].produtoId == produtoId) {
        if (carrinhoComprasItens[i].quantidade > 1 && !removeAll) {
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
  double get subTotal => carrinhoComprasItens.fold(0, (previousValue, item) => previousValue + (item.precoPago * item.quantidade));

  @computed
  double get total => carrinhoComprasItens.fold(0, (previousValue, item) => previousValue + (item.precoPago * item.quantidade));

  void clearCarrinhoCompras() {
    carrinhoComprasItens.clear();
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
        GlobalSnackbar.success('Compra criada com sucesso');
        Modular.to.pop(true);
        clearCarrinhoCompras();
      });
    } finally {
      isLoading = false;
    }
  }
}
