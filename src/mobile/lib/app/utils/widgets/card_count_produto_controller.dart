import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

part 'card_count_produto_controller.g.dart';

class CardCountProdutoController = CardCountProdutoControllerBase with _$CardCountProdutoController;

abstract class CardCountProdutoControllerBase with Store {
  String? produtoId;
  int estoqueDisponivel = 0;

  @observable
  int quantidade = 0;

  void load(String produtoId, int estoqueDisponivel) {
    this.produtoId = produtoId;
    this.estoqueDisponivel = estoqueDisponivel;
  }

  bool isAdicionandoCarrinhoItem = false;

  @action
  Future<void> adicionarCarrinhoItem() async {
    if (!isAdicionandoCarrinhoItem) {
      isAdicionandoCarrinhoItem = true;
      try {
        if (estoqueDisponivel <= quantidade) {
          GlobalSnackbar.error('Sem estoque');
        } else {
          quantidade++;
          await Modular.get<CarrinhoStore>().adicionarCarrinhoItem(produtoId!, 1);
          quantidade++;
        }
      } catch (e) {
        quantidade--;
      } finally {
        isAdicionandoCarrinhoItem = false;
      }
    }
  }

  @action
  Future<void> removerCarrinhoItem() async {
    if (!isAdicionandoCarrinhoItem) {
      isAdicionandoCarrinhoItem = true;
      final itensFaltando = quantidade - estoqueDisponivel;
      try {
        if (itensFaltando > 0) {
          quantidade -= itensFaltando;
          await Modular.get<CarrinhoStore>().removerCarrinhoItem(produtoId!, itensFaltando);
        } else {
          quantidade--;
          await Modular.get<CarrinhoStore>().removerCarrinhoItem(produtoId!, 1);
        }
      } catch (e) {
        if (itensFaltando > 0) {
          quantidade += itensFaltando;
        } else {
          quantidade++;
        }
      } finally {
        isAdicionandoCarrinhoItem = false;
      }
    }
  }
}
