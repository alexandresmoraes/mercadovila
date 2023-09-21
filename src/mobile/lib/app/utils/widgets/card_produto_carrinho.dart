import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/utils/dto/carrinho/carrinho_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_favoritos_repository.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';

class CardProdutoCarrinho extends StatefulWidget {
  final CarrinhoItemDto item;

  const CardProdutoCarrinho({
    super.key,
    required this.item,
  });

  @override
  CardProdutoCarrinhoState createState() => CardProdutoCarrinhoState();
}

class CardProdutoCarrinhoState extends State<CardProdutoCarrinho> {
  bool isFavorito = false;

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
        onTap: () {
          //
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
                        widget.item.nome,
                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                      ),
                      Text(
                        widget.item.descricao,
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RichText(
                          text: TextSpan(text: "R\$ ", style: Theme.of(context).primaryTextTheme.displayMedium, children: [
                        TextSpan(
                          text: '${widget.item.preco}',
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: ' / ${widget.item.unidadeMedida}',
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        )
                      ])),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 18,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "${widget.item.rating} ",
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                children: [
                                  TextSpan(
                                    text: '|',
                                    style: Theme.of(context).primaryTextTheme.displayMedium,
                                  ),
                                  TextSpan(
                                    text: ' ${widget.item.ratingCount} ratings',
                                    style: Theme.of(context).primaryTextTheme.displayLarge,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 20,
                    width: 100,
                    decoration: BoxDecoration(
                      color: widget.item.estoque == 0 ? Colors.redAccent : Colors.green,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.item.getDisponiveis(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      var favoritoRepository = Modular.get<IFavoritosRepository>();
                      try {
                        if (isFavorito) {
                          setState(() {
                            isFavorito = !isFavorito;
                          });
                          await favoritoRepository.removerFavorito(widget.item.produtoId);
                        } else {
                          setState(() {
                            isFavorito = !isFavorito;
                          });
                          await favoritoRepository.adicionarFavorito(widget.item.produtoId);
                        }
                      } catch (e) {
                        setState(() {
                          isFavorito = !isFavorito;
                        });
                      }
                    },
                    icon: isFavorito ? Image.asset('assets/fav_red.png') : Image.asset('assets/fav_grey.png'),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 28,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: const [0, .90],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorLight],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        padding: const EdgeInsets.all(0),
                        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.minus,
                          size: 11,
                          color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                        )),
                    Text(
                      "${widget.item.quantidade}",
                      style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryTextTheme.bodySmall!.color),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.plus,
                        size: 11,
                        color: Theme.of(context).primaryTextTheme.bodySmall!.color,
                      ),
                    ),
                  ],
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
                imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${widget.item.imageUrl}',
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

  @override
  void initState() {
    isFavorito = widget.item.isFavorito;

    super.initState();
  }
}
