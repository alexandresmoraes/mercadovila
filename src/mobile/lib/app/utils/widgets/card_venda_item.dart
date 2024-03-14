import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/utils/dto/vendas/venda_dto.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/rating_produto.dart';

class CardVendaItem extends StatelessWidget {
  final VendaDetalheItemDto item;

  const CardVendaItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () async {
          await Modular.to.pushNamed('/produtos/details/${item.produtoId}');
        },
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 110,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 120),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nome,
                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                      ),
                      Text(
                        item.descricao,
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "R\$ ",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                          children: [
                            TextSpan(
                              text: UtilBrasilFields.obterReal(item.preco * item.quantidade.toDouble(), moeda: false),
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${item.quantidade} x ${item.preco} ${item.unidadeMedida}',
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: RatingProduto(
                          rating: 4.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: -20,
              child: CachedNetworkImage(
                placeholder: (context, url) => const SizedBox(
                  width: 120,
                  height: 100,
                  child: CircularProgress(),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 100,
                  child: Icon(
                    MdiIcons.cameraOff,
                    size: 70,
                    color: Colors.white,
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
                    height: 100,
                    width: 120,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
