import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:vilasesmo/app/utils/widgets/card_count_produto.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';

class CardProdutoColor extends StatelessWidget {
  final CatalogoDto item;
  final int index;

  const CardProdutoColor(
    this.item, {
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: InkWell(
        onTap: () {
          //
        },
        child: Container(
          height: 210,
          margin: const EdgeInsets.only(top: 10, left: 10),
          child: Stack(
            children: [
              SizedBox(
                height: 160,
                width: 140,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: index % 3 == 1
                        ? const LinearGradient(
                            stops: [0, .90],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0XFF9EEEFF), Color(0XFFC0F4FF)],
                          )
                        : index % 3 == 2
                            ? const LinearGradient(
                                stops: [0, .90],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0XFFFFF1C0), Color(0XFFFFF1C0)],
                              )
                            : const LinearGradient(
                                stops: [0, .90],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0XFFFFD4D7), Color(0XFFFFD4D7)],
                              ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(17),
                      bottomLeft: Radius.circular(17),
                      bottomRight: Radius.circular(17),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 27, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          item.nome,
                          style: Theme.of(context).primaryTextTheme.titleMedium,
                        ),
                        Text(
                          item.getDisponiveis(),
                          style: Theme.of(context).primaryTextTheme.titleSmall,
                        ),
                        Container(
                          width: 130,
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "R\$",
                                    style: Theme.of(context).primaryTextTheme.titleSmall,
                                  ),
                                  Text(
                                    '${item.preco} ',
                                    style: Theme.of(context).primaryTextTheme.titleMedium,
                                  ),
                                  Text(
                                    '/ ${item.unidadeMedida}',
                                    style: Theme.of(context).primaryTextTheme.titleSmall,
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Observer(builder: (_) {
                return CardCountProduto(
                  produtoId: item.produtoId,
                  estoqueDisponivel: item.estoque,
                  isAtivo: item.isAtivo,
                  isTop: true,
                  backgroundColor: Colors.white,
                );
              }),
              Positioned(
                bottom: 0,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    height: 120,
                    width: 130,
                    child: CircularProgress(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 120,
                    width: 130,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 100,
                        child: Icon(
                          MdiIcons.cameraOff,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${item.imageUrl}',
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                        ),
                      ),
                      height: 120,
                      width: 130,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
