import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/vendas/venda_dto.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';

class CardVenda extends StatefulWidget {
  final VendaDto item;

  const CardVenda({
    super.key,
    required this.item,
  });

  @override
  CardVendaState createState() => CardVendaState();
}

class CardVendaState extends State<CardVenda> {
  bool isProductsVisible = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Modular.to.pushNamed('/vendas/venda-detalhes');
      },
      child: Column(
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
                Icon(
                  widget.item.status == EnumVendaStatus.cancelada.index ? MdiIcons.closeOctagon : MdiIcons.checkDecagram,
                  size: 20,
                  color: widget.item.status == EnumVendaStatus.cancelada.index
                      ? Colors.red
                      : widget.item.status == EnumVendaStatus.pago.index
                          ? Colors.greenAccent
                          : widget.item.status == EnumVendaStatus.pendentePagamento.index
                              ? Colors.blue
                              : Theme.of(context).primaryColorLight,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.item.status == EnumVendaStatus.cancelada.index
                        ? "Cancelada"
                        : widget.item.status == EnumVendaStatus.pago.index
                            ? "Pago"
                            : widget.item.status == EnumVendaStatus.pendentePagamento.index
                                ? "Pendente de pagamento"
                                : "",
                    style: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -1, horizontal: -4),
            contentPadding: const EdgeInsets.all(0),
            minLeadingWidth: 0,
            leading: isNullorEmpty(widget.item.compradorFotoUrl)
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
                      placeholder: (context, url) => CircularProgress(
                        color: Theme.of(context).primaryColorLight,
                      ),
                      errorWidget: (context, url, error) {
                        return const CircleAvatar(
                          radius: 21,
                          backgroundImage: AssetImage('assets/person.png'),
                        );
                      },
                      imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/account/photo/${widget.item.compradorFotoUrl!}',
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 21,
                          backgroundImage: imageProvider,
                        );
                      },
                    ),
                  ),
            title: Text(
              widget.item.compradorNome,
              style: Theme.of(context).primaryTextTheme.bodyLarge,
            ),
            subtitle: Text(
              "${widget.item.dataHora}",
              style: Theme.of(context).primaryTextTheme.displayMedium,
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "R\$ ${widget.item.total}",
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
            height: isProductsVisible ? 180 : 0,
            child: SingleChildScrollView(
              child: SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _vendaItens(widget.item.itens),
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
      ),
    );
  }

  List<Widget> _vendaItens(List<VendaItemDto> itens) {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < itens.length; i++) {
        widgetList.add(
          Container(
            height: 172,
            margin: const EdgeInsets.only(top: 40, left: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 172,
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
                            '${itens[i].quantidade} ${itens[i].unidadeMedida}',
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ' ',
                                    style: Theme.of(context).primaryTextTheme.displayMedium,
                                  ),
                                  Text(
                                    'R\$ ',
                                    style: TextStyle(fontSize: 10, color: Theme.of(context).primaryTextTheme.displayMedium!.color),
                                  ),
                                  Text(
                                    '${itens[i].preco}',
                                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                                  )
                                ],
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
        print("Exception - _vendaItens(): $e");
      }
      return widgetList;
    }
  }
}