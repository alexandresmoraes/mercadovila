import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/compras/compra_dto.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class CardCompra extends StatefulWidget {
  final CompraDto item;

  const CardCompra({
    super.key,
    required this.item,
  });

  @override
  CardCompraState createState() => CardCompraState();
}

class CardCompraState extends State<CardCompra> {
  bool isProductsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Modular.get<ThemeStore>().isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  '#${widget.item.id}',
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
        ListTile(
          visualDensity: const VisualDensity(vertical: -1, horizontal: -4),
          contentPadding: const EdgeInsets.all(0),
          minLeadingWidth: 0,
          leading: isNullorEmpty(widget.item.usuarioFotoUrl)
              ? const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/person.png'),
                  ),
                )
              : CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: SpinKitThreeBounce(
                        size: 20,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return const CircleAvatar(
                        radius: 21,
                        backgroundImage: AssetImage('assets/person.png'),
                      );
                    },
                    imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/account/photo/${widget.item.usuarioFotoUrl!}',
                    imageBuilder: (context, imageProvider) {
                      return CircleAvatar(
                        radius: 24,
                        backgroundImage: imageProvider,
                      );
                    },
                  ),
                ),
          title: Text(
            widget.item.usuarioNome,
            style: Theme.of(context).primaryTextTheme.bodyLarge,
          ),
          subtitle: Text(
            timeago.format(locale: 'pt_BR', widget.item.dataHora.toLocal()),
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                UtilBrasilFields.obterReal(widget.item.total.toDouble()),
                style: Theme.of(context).primaryTextTheme.bodyLarge,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isProductsVisible = !isProductsVisible;
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFFF05656), borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 10, top: 5),
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  width: 80,
                  height: 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 0,
                        ),
                        child: Text(
                          'Detalhes',
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isProductsVisible ? 250 : 0,
          child: SingleChildScrollView(
            child: SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _compraItens(widget.item.itens),
              ),
            ),
          ),
        ),
        Divider(
          color: Modular.get<ThemeStore>().isDarkModeEnable
              ? Theme.of(context).dividerTheme.color!.withOpacity(0.05)
              : Theme.of(context).dividerTheme.color,
        ),
      ],
    );
  }

  List<Widget> _compraItens(List<CompraItemDto> itens) {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < itens.length; i++) {
        widgetList.add(
          Container(
            height: 220,
            margin: const EdgeInsets.only(top: 40, left: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 220,
                  width: 145,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 78, left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itens[i].nome,
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                          Text(
                            itens[i].descricao,
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "R\$ ",
                                      style: Theme.of(context).primaryTextTheme.displayMedium,
                                      children: [
                                        TextSpan(
                                          text: UtilBrasilFields.obterReal(itens[i].precoPago * itens[i].quantidade.toDouble(), moeda: false),
                                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${itens[i].quantidade} x ${UtilBrasilFields.obterReal(itens[i].precoPago.toDouble(), moeda: false)} ${itens[i].unidadeMedida}',
                                style: Theme.of(context).primaryTextTheme.displayMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -40,
                  left: 8,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      height: 120,
                      width: 130,
                      child: SpinKitThreeBounce(
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
                    imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${itens[i].imageUrl}',
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
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      if (kDebugMode) {
        print("Exception - compras_page.dart - _allItemsWidgetList():$e");
      }
      return widgetList;
    }
  }
}
