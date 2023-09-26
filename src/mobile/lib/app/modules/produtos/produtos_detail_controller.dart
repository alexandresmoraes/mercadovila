import 'package:barcode/barcode.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/produtos/produto_detail_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_produtos_repository.dart';

part 'produtos_detail_controller.g.dart';

class ProdutosDetailController = ProdutosDetailControllerBase with _$ProdutosDetailController;

abstract class ProdutosDetailControllerBase with Store {
  String? id;

  @observable
  String? svgCodigoBarras;

  @observable
  bool isLoading = false;

  @observable
  bool isFavorito = false;

  @observable
  bool isVisibleFavoritos = false;

  ProdutoDetailDto? produtoDetailDto;

  Future<ProdutoDetailDto?> load() async {
    if (produtoDetailDto != null) return produtoDetailDto!;
    isLoading = true;

    var produtosRepository = Modular.get<IProdutosRepository>();
    produtoDetailDto = await produtosRepository.getProdutoDetail(id!);

    final ean = Barcode.ean13();
    svgCodigoBarras = ean.toSvg(produtoDetailDto!.codigoBarras, width: 200, height: 80);
    pictureInfo = await vg.loadPicture(SvgStringLoader(svgCodigoBarras!), null);

    isFavorito = produtoDetailDto!.isFavorito;

    isLoading = false;
    return produtoDetailDto!;
  }

  @observable
  PictureInfo? pictureInfo;
}
