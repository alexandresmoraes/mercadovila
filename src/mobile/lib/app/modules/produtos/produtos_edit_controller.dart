import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/models/produtos/produto_model.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

part 'produtos_edit_controller.g.dart';

class ProdutosEditController = ProdutosEditControllerBase with _$ProdutosEditController;

abstract class ProdutosEditControllerBase with Store {
  String? id;

  @observable
  bool isFotoAlterada = false;

  @observable
  String? photoPath;
  @action
  void setPhotoPath(String v) {
    isFotoAlterada = true;
    photoPath = v;
  }

  @observable
  String? nome;
  @observable
  String? _nomeApiError;
  @computed
  String? get getNomeError => !isNullorEmpty(_nomeApiError)
      ? _nomeApiError
      : isNullorEmpty(nome)
          ? 'Nome do produto não pode ser vazio.'
          : null;
  @action
  void setNome(String? v) {
    nome = v;
    _nomeApiError = null;
  }

  @observable
  String? descricao;
  @observable
  String? _descricaoApiError;
  @computed
  String? get getDescricaoError => !isNullorEmpty(_descricaoApiError)
      ? _descricaoApiError
      : isNullorEmpty(descricao)
          ? 'Descrição do produto não pode ser vazio.'
          : null;
  @action
  void setDescricao(String? v) {
    descricao = v;
    _descricaoApiError = null;
  }

  @observable
  String? preco;
  @observable
  String? _precoApiError;
  @computed
  String? get getPrecoError => !isNullorEmpty(_precoApiError)
      ? _precoApiError
      : isNullorEmpty(preco)
          ? 'Preço do produto não pode ser vazio.'
          : null;
  @action
  void setPreco(String? v) {
    preco = v;
    _precoApiError = null;
  }

  @observable
  String? unidadeMedida;
  @observable
  String? _unidadeMedidaApiError;
  @computed
  String? get getUnidadeMedidaError => !isNullorEmpty(_unidadeMedidaApiError)
      ? _unidadeMedidaApiError
      : isNullorEmpty(unidadeMedida)
          ? 'Unidade de medida do produto não pode ser vazio.'
          : null;
  @action
  void setUnidadeMedida(String? v) {
    unidadeMedida = v;
    _unidadeMedidaApiError = null;
  }

  @observable
  String? codigoBarras;
  @observable
  String? _codigoBarrasApiError;
  @computed
  String? get getCodigoBarrasError => !isNullorEmpty(_codigoBarrasApiError)
      ? _codigoBarrasApiError
      : isNullorEmpty(codigoBarras)
          ? 'Código de barras do produto não pode ser vazio.'
          : null;
  @action
  void setCodigoBarras(String? v) {
    codigoBarras = v;
    _codigoBarrasApiError = null;
  }

  @observable
  String? estoqueAlvo;
  @observable
  String? _estoqueAlvoApiError;
  @computed
  String? get getEstoqueAlvoError => !isNullorEmpty(_estoqueAlvoApiError)
      ? _estoqueAlvoApiError
      : isNullorEmpty(estoqueAlvo)
          ? 'Estoque alvo do produto não pode ser vazio.'
          : null;
  @action
  void setEstoqueAlvo(String? v) {
    estoqueAlvo = v;
    _estoqueAlvoApiError = null;
  }

  @observable
  String? estoque;
  @observable
  String? _estoqueApiError;
  @computed
  String? get getEstoqueError => !isNullorEmpty(_estoqueAlvoApiError)
      ? _estoqueApiError
      : isNullorEmpty(estoque)
          ? 'Estoque do produto não pode ser vazio.'
          : null;
  @action
  void setEstoque(String? v) {
    estoque = v;
    _estoqueApiError = null;
  }

  @observable
  bool isAtivo = false;
  @action
  void setIsAtivo(bool v) => isAtivo = v;

  @observable
  bool isSaving = false;
  @observable
  bool isLoading = false;
  @observable
  bool isPasswordVisible = false;
  @observable
  bool isConfirmPasswordVisible = false;

  @computed
  bool get isValid =>
      isNullorEmpty(getNomeError) &&
      isNullorEmpty(getDescricaoError) &&
      isNullorEmpty(getPrecoError) &&
      isNullorEmpty(getUnidadeMedidaError) &&
      isNullorEmpty(getCodigoBarrasError) &&
      isNullorEmpty(getEstoqueAlvoError) &&
      isNullorEmpty(getEstoqueError);

  ProdutoModel? produtoModel;

  Future<ProdutoModel?> load() async {
    if (produtoModel != null) return produtoModel!;
    isLoading = true;

    if (!isNullorEmpty(id)) {
      produtoModel = null;
    } else {
      produtoModel = ProdutoModel(
          nome: "",
          descricao: "",
          preco: "",
          unidadeMedida: "",
          codigoBarras: "",
          estoqueAlvo: "",
          estoque: "",
          isAtivo: true);
    }

    nome = produtoModel!.nome;
    descricao = produtoModel!.descricao;
    preco = produtoModel!.preco;
    unidadeMedida = produtoModel!.unidadeMedida;
    codigoBarras = produtoModel!.codigoBarras;
    estoqueAlvo = produtoModel!.estoqueAlvo;
    estoque = produtoModel!.estoque;
    isAtivo = produtoModel!.isAtivo;

    isLoading = false;
    return produtoModel!;
  }

  Future save() async {
    try {
      isSaving = true;

      // var accountRepository = Modular.get<IAccountRepository>();
      // if (isNullorEmpty(id)) {
      //   var result = await accountRepository.newAccount(NewAndUpdateAccountModel(
      //     nome: "",

      //   ));

      //   result.fold(apiErrors, (accountResponse) async {
      //     GlobalSnackbar.success('Criado com sucesso!');
      //     Modular.to.pop();
      //   });
      // } else {
      //   var result = await accountRepository.updateAccount(id!, newAndUpdateAccountModel);

      //   result.fold(apiErrors, (accountResponse) async {
      //     var me = await Modular.get<IAuthService>().me();
      //     Modular.get<AccountStore>().setAccount(me);
      //     GlobalSnackbar.success('Editado com sucesso!');
      //     Modular.to.pop();
      //   });
      // }
    } catch (e) {
      isSaving = false;
    }
  }

  void apiErrors(ResultFailModel resultFail) {
    isSaving = false;

    if (resultFail.statusCode == 400) {
      _nomeApiError = resultFail.getErrorByProperty('Nome');
      _descricaoApiError = resultFail.getErrorByProperty('Descricao');
      _precoApiError = resultFail.getErrorByProperty('Preco');
      _unidadeMedidaApiError = resultFail.getErrorByProperty('UnidadeMedida');
      _codigoBarrasApiError = resultFail.getErrorByProperty('CodigoBarras');
      _estoqueAlvoApiError = resultFail.getErrorByProperty('EstoqueAlvo');
      _estoqueApiError = resultFail.getErrorByProperty('Estoque');

      var message = resultFail.getErrorNotProperty();
      if (message.isNotEmpty) GlobalSnackbar.error(message);
    }
  }
}
