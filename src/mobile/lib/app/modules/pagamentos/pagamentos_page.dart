import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/modules/pagamentos/pagamentos_pagar_controller.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/pagamentos/pagamentos_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_pagamentos_repository.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:mercadovila/app/utils/widgets/circular_progress.dart';
import 'package:mercadovila/app/utils/widgets/global_snackbar.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';

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
    return DefaultTabController(
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
              child: _todosPagamentos(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todosPagamentos() {
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
          return Slidable(
            enabled: item.pagamentoStatus != EnumStatusPagamento.cancelado.index,
            key: Key(item.pagamentoId.toString()),
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              dismissible: DismissiblePane(
                closeOnCancel: true,
                confirmDismiss: () {
                  return cancelar(item.pagamentoId);
                },
                onDismissed: () {},
              ),
              children: [
                SlidableAction(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.red,
                  label: 'Cancelar?',
                  icon: MdiIcons.closeOctagon,
                  onPressed: (_) {
                    cancelar(item.pagamentoId);
                  },
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
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
                        '#${item.pagamentoId}',
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.compradorEmail,
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Row(
                        children: [
                          Text(
                            isNullorEmpty(item.canceladoPor) ? 'Recebido por: ' : 'Cancelado por: ',
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                          Text(
                            isNullorEmpty(item.canceladoPor) ? item.recebidoPor : item.canceladoPor!,
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                        ],
                      ),
                      item.pagamentoTipo.toInt() == EnumTipoPagamento.descontoEmFolha.index
                          ? Row(
                              children: [
                                Text(
                                  'Mês de referência: ',
                                  style: Theme.of(context).primaryTextTheme.displayMedium,
                                ),
                                Text(
                                  Modular.get<PagamentosPagarController>().enumMesReferencia[item.mesReferencia]!,
                                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      Text(
                        isNullorEmpty(item.canceladoPor)
                            ? '${UtilData.obterDataDDMMAAAA(item.pagamentoDataHora.toLocal())} ${UtilData.obterHoraHHMM(item.pagamentoDataHora.toLocal())}'
                            : '${UtilData.obterDataDDMMAAAA(item.dataCancelamento!.toLocal())} ${UtilData.obterHoraHHMM(item.dataCancelamento!.toLocal())}',
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            UtilBrasilFields.obterReal(item.pagamentoValor.toDouble()),
                            style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              item.pagamentoTipo == EnumTipoPagamento.descontoEmFolha.index ? Icons.account_balance : MdiIcons.cash,
                              size: 20,
                              color: item.pagamentoTipo == EnumTipoPagamento.descontoEmFolha.index
                                  ? Colors.blue
                                  : Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Colors.greenAccent
                                      : Colors.green,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                item.pagamentoTipo == EnumTipoPagamento.descontoEmFolha.index ? "Desconto em folha" : "Dinheiro",
                                style: Theme.of(context).primaryTextTheme.displayMedium,
                              ),
                            ),
                          ],
                        ),
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

  Future<bool> cancelar(int pagamentoId) async {
    return await showCupertinoModalPopup<bool>(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            title: const Icon(Icons.question_answer),
            actions: <Widget>[
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () async {
                  var pagamentoRepository = Modular.get<IPagamentosRepository>();
                  var result = await pagamentoRepository.cancelarPagamento(pagamentoId);

                  result.fold((l) {
                    var message = l.getErrorNotProperty();
                    GlobalSnackbar.error(message);
                    Modular.to.pop(false);
                  }, (r) {
                    GlobalSnackbar.success('Pagamento cancelado');
                    pagingController.refresh();
                    Modular.to.pop(true);
                  });
                },
                child: const Text(
                  'Sim',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Modular.to.pop(false);
                },
                child: const Text(
                  'Não',
                ),
              ),
            ],
          ),
        ) ??
        false;
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
