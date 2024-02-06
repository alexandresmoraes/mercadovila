import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/pagamentos/pagamentos_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_pagamentos_repository.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';

class PagamentosPage extends StatefulWidget {
  final String title;
  const PagamentosPage({Key? key, this.title = 'Pagamentos'}) : super(key: key);
  @override
  PagamentosPageState createState() => PagamentosPageState();
}

class PagamentosPageState extends State<PagamentosPage> {
  String? usernameFilter;
  bool isSearchVisibled = false;
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  Timer? _debounce;

  PagingController<int, PagamentosDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Pagamentos",
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  setState(() {
                    isSearchVisibled = !isSearchVisibled;
                    if (!isSearchVisibled && !isNullorEmpty(usernameFilter)) {
                      usernameFilter = "";
                      searchController.clear();
                      pagingController.refresh();
                    }
                    if (isSearchVisibled) {
                      searchNode.requestFocus();
                    } else {
                      searchNode.unfocus();
                    }
                  });
                },
                icon: const Icon(MdiIcons.magnify),
              ),
              IconButton(
                onPressed: () async {
                  var refresh = await Modular.to.pushNamed<bool>('/pagamentos/pagar');
                  if (refresh ?? false) pagingController.refresh();
                },
                icon: const Icon(MdiIcons.plus),
              ),
            ],
          ),
          body: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isSearchVisibled ? 70 : 0,
                child: Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(),
                  child: TextFormField(
                    focusNode: searchNode,
                    controller: searchController,
                    onChanged: ((value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        setState(() {
                          usernameFilter = value;
                          pagingController.refresh();
                        });
                      });
                    }),
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome de usuários ou email',
                      prefixIcon: Icon(
                        MdiIcons.magnify,
                        size: isSearchVisibled ? 20 : 0,
                      ),
                      contentPadding: const EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _allPagamentos(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allPagamentos() {
    final ThemeStore themeStore = Modular.get<ThemeStore>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<PagamentosDto>(
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<IPagamentosRepository>().getPagamentos(page, usernameFilter);
        },
        cast: PagamentosDto.fromJson,
        noMoreItemsBuilder: const SizedBox.shrink(),
        emptyBuilder: (_) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/empty_list.png',
                  width: 300,
                  height: 300,
                ),
              ],
            ),
          );
        },
        itemBuilder: (context, item, index) {
          return InkWell(
            onTap: () async {
              // TODO
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: themeStore.isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Text(
                          '#${item.pagamentoId.toString()}',
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Icon(
                        item.pagamentoStatus == EnumStatusPagamento.cancelado.index ? MdiIcons.closeOctagon : MdiIcons.checkDecagram,
                        size: 20,
                        color: item.pagamentoStatus == EnumStatusPagamento.cancelado.index
                            ? Colors.red
                            : Modular.get<ThemeStore>().isDarkModeEnable
                                ? Colors.greenAccent
                                : Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          item.pagamentoStatus == EnumStatusPagamento.ativo.index ? "Ativo" : "Cancelado",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                  contentPadding: const EdgeInsets.all(0),
                  minLeadingWidth: 0,
                  leading: isNullorEmpty(item.compradorFotoUrl)
                      ? const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 21,
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
                            imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/account/photo/${item.compradorFotoUrl!}',
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                radius: 21,
                                backgroundImage: imageProvider,
                              );
                            },
                          ),
                        ),
                  title: Text(
                    item.compradorNome,
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    item.compradorEmail,
                    style: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "R\$ ${item.pagamentoValor}",
                        style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: themeStore.isDarkModeEnable ? Theme.of(context).dividerTheme.color!.withOpacity(0.05) : Theme.of(context).dividerTheme.color,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
