import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mercadovila/app/modules/carrinho/carrinho_store.dart';
import 'package:mercadovila/app/utils/widgets/global_snackbar.dart';

part 'card_count_produto_controller.g.dart';

class CardCountProdutoController = CardCountProdutoControllerBase with _$CardCountProdutoController;

abstract class CardCountProdutoControllerBase with Store {
  CarrinhoStore carrinhoStore = Modular.get<CarrinhoStore>();

  String? produtoId;
  int estoqueDisponivel = 0;

  @observable
  int quantidade = 0;

  void load(String produtoId, int estoqueDisponivel) {
    this.produtoId = produtoId;
    this.estoqueDisponivel = estoqueDisponivel;
  }

  @action
  Future<void> adicionarCarrinhoItem() async {
    if (!carrinhoStore.isAdicionandoCarrinhoItem) {
      carrinhoStore.isAdicionandoCarrinhoItem = true;
      try {
        if (estoqueDisponivel <= quantidade) {
          GlobalSnackbar.error('Sem estoque');
        } else {
          quantidade++;
          await carrinhoStore.adicionarCarrinhoItem(produtoId!, 1);
        }
      } catch (e) {
        quantidade--;
      } finally {
        carrinhoStore.isAdicionandoCarrinhoItem = false;
      }
    }
  }

  @action
  Future<void> removerCarrinhoItem() async {
    if (!carrinhoStore.isAdicionandoCarrinhoItem) {
      carrinhoStore.isAdicionandoCarrinhoItem = true;
      final itensFaltando = quantidade - estoqueDisponivel;
      try {
        if (itensFaltando > 0) {
          quantidade -= itensFaltando;
          await carrinhoStore.removerCarrinhoItem(produtoId!, itensFaltando);
        } else {
          quantidade--;
          await carrinhoStore.removerCarrinhoItem(produtoId!, 1);
        }
      } catch (e) {
        if (itensFaltando > 0) {
          quantidade += itensFaltando;
        } else {
          quantidade++;
        }
      } finally {
        carrinhoStore.isAdicionandoCarrinhoItem = false;
      }
    }
  }
}
