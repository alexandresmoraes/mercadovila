import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/pagamentos/pagamentos_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_pagamentos_repository.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:mercadovila/app/utils/widgets/card_account_loading.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';

class MeusPagamentosPage extends StatefulWidget {
  final String title;
  const MeusPagamentosPage({Key? key, this.title = 'Meus Pagamentos'}) : super(key: key);
  @override
  MeusPagamentosPageState createState() => MeusPagamentosPageState();
}

class MeusPagamentosPageState extends State<MeusPagamentosPage> {
  PagingController<int, PagamentosDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Meus Pagamentos",
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _meusPagamentos(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _meusPagamentos() {
    final ThemeStore themeStore = Modular.get<ThemeStore>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<PagamentosDto>(
        firstPageProgressIndicatorWidget: CardAccountLoading(),
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<IPagamentosRepository>().getMeusPagamentos(page);
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
          return Column(
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
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            child: SpinKitThreeBounce(
                              size: 25,
                              color: Theme.of(context).primaryColorLight,
                            ),
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
                      padding: const EdgeInsets.only(top: 5),
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
                    )
                  ],
                ),
              ),
              Divider(
                color: themeStore.isDarkModeEnable ? Theme.of(context).dividerTheme.color!.withOpacity(0.05) : Theme.of(context).dividerTheme.color,
              ),
            ],
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
