import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/produtos/produto_detail_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_produtos_repository.dart';
import 'package:vilasesmo/app/utils/utils.dart';

part 'produtos_detail_controller.g.dart';

class ProdutosDetailController = ProdutosDetailControllerBase with _$ProdutosDetailController;

abstract class ProdutosDetailControllerBase with Store {
  String? id;

  @observable
  bool isLoading = false;

  @observable
  bool isFavorito = false;

  ProdutoDetailDto? produtoDetailDto;

  Future<ProdutoDetailDto?> load() async {
    if (produtoDetailDto != null) return produtoDetailDto!;
    isLoading = true;

    var produtosRepository = Modular.get<IProdutosRepository>();
    produtoDetailDto = await produtosRepository.getProdutoDetail(id!);

    isFavorito = produtoDetailDto!.isFavorito;

    isLoading = false;
    return produtoDetailDto!;
  }
}
