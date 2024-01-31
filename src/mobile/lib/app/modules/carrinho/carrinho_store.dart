import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:vilasesmo/app/stores/pagamentos_store.dart';
import 'package:vilasesmo/app/utils/dto/carrinho/carrinho_dto.dart';
import 'package:vilasesmo/app/utils/models/vendas/venda_model.dart';
import 'package:vilasesmo/app/utils/repositories/carrinho_repository.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_carrinho_repository.dart';
import 'package:vilasesmo/app/utils/repositories/vendas_repository.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

part 'carrinho_store.g.dart';

class CarrinhoStore = CarrinhoStoreBase with _$CarrinhoStore;

abstract class CarrinhoStoreBase with Store {
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

  bool isAdicionandoCarrinhoItem = false;

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

  int getCarrinhoItemQuantidade(String produtoId) {
    for (var item in carrinhoItens) {
      if (item.produtoId == produtoId) {
        return item.quantidade;
      }
    }

    return 0;
  }

  Future<void> adicionarCarrinhoItem(String produtoId, int quantidade) async {
    try {
      isLoading = true;

      var carrinhoRepository = Modular.get<CarrinhoRepository>();
      await carrinhoRepository.adicionarCarrinho(produtoId, quantidade);

      await load();
    } finally {
      isLoading = false;
    }
  }

  Future<void> removerCarrinhoItem(String produtoId, int quantidade) async {
    try {
      isLoading = true;

      var carrinhoRepository = Modular.get<CarrinhoRepository>();
      await carrinhoRepository.removerCarrinho(produtoId, quantidade);

      await load();
    } finally {
      isLoading = false;
    }
  }

  Future<void> criarVenda() async {
    if (!selectOpcaoPagamento) {
      GlobalSnackbar.error("Selecione a forma de pagamento.");
      return;
    }

    try {
      isLoading = true;

      var vendasRepository = Modular.get<VendasRepository>();
      var compradorNome = Modular.get<AccountStore>().account!.nome;
      var compradorFotoUrl = Modular.get<AccountStore>().account!.fotoUrl;
      var result = await vendasRepository.createVenda(VendaModel(
        compradorNome: compradorNome,
        compradorFotoUrl: compradorFotoUrl,
      ));

      await result.fold((resultFail) {
        var message = resultFail.getErrorNotProperty();
        if (message.isNotEmpty) GlobalSnackbar.error(message);
      }, (response) async {
        GlobalSnackbar.success("Compra efetuada com sucesso.");
        await load();
        await Modular.get<PagamentosStore>().load();
        Modular.to.pop();
        setSelectOpcaoPagamento(false);
      });
    } finally {
      isLoading = false;
    }
  }
}
