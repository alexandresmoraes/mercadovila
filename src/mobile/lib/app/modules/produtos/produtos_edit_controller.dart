import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:mercadovila/app/utils/models/produtos/produto_model.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_produtos_repository.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:mercadovila/app/utils/widgets/global_snackbar.dart';

part 'produtos_edit_controller.g.dart';

class ProdutosEditController = ProdutosEditControllerBase with _$ProdutosEditController;

abstract class ProdutosEditControllerBase with Store {
  String? id;

  @observable
  String? imagePath;
  @action
  void setImagePath(String v) {
    imagePath = v;
  }

  @observable
  String? imageMimeType;

  @observable
  String? imageFilenameWeb;

  @observable
  String? imageUrl;
  @computed
  String? get getImageUrlError => isNullorEmpty(imageUrl) ? 'Imagem do produto não pode ser vazio.' : null;

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
  double? preco;
  @observable
  String? _precoApiError;
  @computed
  String? get getPrecoError => !isNullorEmpty(_precoApiError)
      ? _precoApiError
      : isNullorEmpty(preco.toString())
          ? 'Preço do produto não pode ser vazio.'
          : null;
  @action
  void setPreco(double? v) {
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

  TextEditingController codigoBarrasController = TextEditingController();

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
    codigoBarrasController.text = v!;
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
  bool get isValid {
    var imageUrlError = getImageUrlError;
    if (!isNullorEmpty(imageUrlError) && isNullorEmpty(imagePath)) {
      GlobalSnackbar.error(imageUrlError!);
    }
    return isNullorEmpty(getNomeError) &&
        isNullorEmpty(getDescricaoError) &&
        isNullorEmpty(getPrecoError) &&
        isNullorEmpty(getUnidadeMedidaError) &&
        isNullorEmpty(getCodigoBarrasError) &&
        isNullorEmpty(getEstoqueAlvoError);
  }

  ProdutoModel? produtoModel;

  Future<ProdutoModel?> load() async {
    if (produtoModel != null) return produtoModel!;
    isLoading = true;

    if (!isNullorEmpty(id)) {
      var produtosRepository = Modular.get<IProdutosRepository>();
      produtoModel = await produtosRepository.getProduto(id!);
    } else {
      produtoModel = ProdutoModel(
        nome: "",
        descricao: "",
        imageUrl: "",
        preco: 0,
        unidadeMedida: "",
        codigoBarras: "",
        estoqueAlvo: 0,
        isAtivo: true,
      );
    }

    nome = produtoModel!.nome;
    descricao = produtoModel!.descricao;
    imageUrl = produtoModel!.imageUrl;
    preco = produtoModel!.preco;
    unidadeMedida = produtoModel!.unidadeMedida;
    codigoBarras = produtoModel!.codigoBarras;
    estoqueAlvo = produtoModel!.estoqueAlvo == 0 ? "0" : produtoModel!.estoqueAlvo.toString();
    isAtivo = produtoModel!.isAtivo;

    codigoBarrasController.text = codigoBarras!;

    isLoading = false;
    return produtoModel!;
  }

  Future saveProduto() async {
    var produtoModel = ProdutoModel(
      nome: nome!,
      descricao: descricao!,
      imageUrl: imageUrl!,
      preco: preco!,
      unidadeMedida: unidadeMedida!,
      codigoBarras: codigoBarras!,
      estoqueAlvo: int.parse(estoqueAlvo!),
      isAtivo: isAtivo,
    );

    var produtoRepository = Modular.get<IProdutosRepository>();
    if (isNullorEmpty(id)) {
      var result = await produtoRepository.createProduto(produtoModel);

      await result.fold((fail) {
        apiErrors(fail);
      }, (response) async {
        GlobalSnackbar.success('Criado com sucesso');
        Modular.to.pop(true);
      });
    } else {
      var result = await produtoRepository.editProduto(id!, produtoModel);

      await result.fold((fail) {
        apiErrors(fail);
      }, (accountResponse) async {
        GlobalSnackbar.success('Editado com sucesso');
        Modular.to.pop(true);
      });
    }
  }

  Future save() async {
    try {
      isSaving = true;
      var produtosRepository = Modular.get<IProdutosRepository>();

      if (!isNullorEmpty(imagePath)) {
        var result = await produtosRepository.uploadImageProdutos(imagePath!, imageMimeType, imageFilenameWeb);
        await result.fold((fail) {
          if (fail.statusCode == 413) {
            GlobalSnackbar.error('Tamanho máximo da imagem é 8MB');
            isSaving = false;
          }
        }, (response) async {
          imageUrl = response.filename;

          await saveProduto();
        });
      } else {
        await saveProduto();
      }
    } finally {
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

      var message = resultFail.getErrorNotProperty();
      if (message.isNotEmpty) GlobalSnackbar.error(message);
    }
  }
}
