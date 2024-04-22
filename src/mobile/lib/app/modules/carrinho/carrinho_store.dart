import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mercadovila/app/stores/account_store.dart';
import 'package:mercadovila/app/stores/pagamentos_store.dart';
import 'package:mercadovila/app/utils/dto/carrinho/carrinho_dto.dart';
import 'package:mercadovila/app/utils/models/vendas/venda_model.dart';
import 'package:mercadovila/app/utils/repositories/carrinho_repository.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_carrinho_repository.dart';
import 'package:mercadovila/app/utils/repositories/vendas_repository.dart';
import 'package:mercadovila/app/utils/widgets/global_snackbar.dart';

part 'carrinho_store.g.dart';

class CarrinhoStore = CarrinhoStoreBase with _$CarrinhoStore;

abstract class CarrinhoStoreBase with Store {
  @observable
  bool isDescontoSalario = false;

  @action
  void setDescontoSalario() {
    isDescontoSalario = true;
    isDinheiro = false;
  }

  @observable
  bool isDinheiro = false;

  @action
  void setDinheiro() {
    isDinheiro = true;
    isDescontoSalario = false;
  }

  @observable
  ObservableList<CarrinhoItemDto> carrinhoItens = ObservableList<CarrinhoItemDto>();

  @computed
  bool get isValidCarrinho => carrinhoItens.isNotEmpty;

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
    if (!isDescontoSalario && !isDinheiro) {
      GlobalSnackbar.error("Selecione a forma de pagamento.");
      return;
    }

    try {
      isLoading = true;

      var vendasRepository = Modular.get<VendasRepository>();
      var compradorNome = Modular.get<AccountStore>().account!.nome;
      var compradorFotoUrl = Modular.get<AccountStore>().account!.fotoUrl;

      var result = await vendasRepository.criarVenda(VendaModel(
        compradorNome: compradorNome,
        compradorFotoUrl: compradorFotoUrl,
        tipoPagamento: isDescontoSalario ? 0 : 1,
      ));

      await result.fold((resultFail) {
        var message = resultFail.getErrorNotProperty();
        if (message.isNotEmpty) GlobalSnackbar.error(message);
      }, (response) async {
        Modular.to.pushNamedAndRemoveUntil('/carrinho/success', (Route<dynamic> route) => false);
        await load();
        await Modular.get<PagamentosStore>().load();
        isDescontoSalario = false;
        isDinheiro = false;
      });
    } finally {
      isLoading = false;
    }
  }
}
