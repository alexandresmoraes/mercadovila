import 'package:barcode/barcode.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobx/mobx.dart';
import 'package:mercadovila/app/utils/dto/produtos/produto_detail_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_produtos_repository.dart';

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
  bool isVisibleFavoritos = true;

  ProdutoDetailDto? produtoDetailDto;

  Future<ProdutoDetailDto?> load() async {
    if (produtoDetailDto != null) return produtoDetailDto!;
    isLoading = true;

    var produtosRepository = Modular.get<IProdutosRepository>();
    produtoDetailDto = await produtosRepository.getProdutoDetail(id!);

    if (produtoDetailDto!.codigoBarras.length == 13) {
      final ean = Barcode.ean13();
      svgCodigoBarras = ean.toSvg(produtoDetailDto!.codigoBarras, width: 180, height: 70);
      pictureInfo = await vg.loadPicture(SvgStringLoader(svgCodigoBarras!), null);
    } else if (produtoDetailDto!.codigoBarras.length == 8) {
      final ean = Barcode.ean8();
      svgCodigoBarras = ean.toSvg(produtoDetailDto!.codigoBarras, width: 180, height: 70);
      pictureInfo = await vg.loadPicture(SvgStringLoader(svgCodigoBarras!), null);
    }
    isFavorito = produtoDetailDto!.isFavorito;

    isLoading = false;
    return produtoDetailDto!;
  }

  @observable
  PictureInfo? pictureInfo;
}
