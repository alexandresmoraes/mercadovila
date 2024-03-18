import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/pagamentos/pagamentos_pagar_controller.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/account/account_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_account_repository.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';

class PagamentosPagarPage extends StatefulWidget {
  final String title;

  const PagamentosPagarPage({Key? key, this.title = 'Pagamento'}) : super(key: key);

  @override
  PagamentosPagarPageState createState() => PagamentosPagarPageState();
}

class PagamentosPagarPageState extends State<PagamentosPagarPage> {
  final PagamentosPagarController _controller = Modular.get<PagamentosPagarController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Modular.get<ThemeStore>().isDarkModeEnable
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).inputDecorationTheme.fillColor,
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Pagamento'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  color: Colors.transparent,
                  alignment: Alignment.topCenter,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: 200,
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/profile_edit.png'),
                            ),
                          ),
                          alignment: Alignment.topCenter,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black,
                              child: Observer(builder: (_) {
                                if (_controller.isPagamentoDetalheSelected && !isNullorEmpty(_controller.pagamentoDetalheDto!.compradorFotoUrl)) {
                                  return CachedNetworkImage(
                                    placeholder: (context, url) => CircularProgress(
                                      color: Theme.of(context).primaryColorLight,
                                      width: 100,
                                      height: 100,
                                    ),
                                    errorWidget: (context, url, error) => const CircleAvatar(
                                      radius: 100,
                                      backgroundImage: AssetImage('assets/person.png'),
                                    ),
                                    imageUrl:
                                        '${Modular.get<BaseOptions>().baseUrl}/api/account/photo/${_controller.pagamentoDetalheDto!.compradorFotoUrl}',
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                        radius: 100,
                                        backgroundImage: imageProvider,
                                      );
                                    },
                                  );
                                }

                                return const CircleAvatar(
                                  radius: 100,
                                  backgroundImage: AssetImage('assets/person.png'),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                      Observer(builder: (_) {
                        if (!_controller.isPagamentoDetalheSelected) {
                          return const SizedBox.shrink();
                        }

                        return Positioned(
                          bottom: 15,
                          child: Text(
                            _controller.pagamentoDetalheDto!.compradorNome ?? "",
                            style: Theme.of(context).primaryTextTheme.displayLarge,
                          ),
                        );
                      })
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TypeAheadField<AccountDto>(
                    controller: _controller.usuarioEditingController,
                    emptyBuilder: (context) => const SizedBox.shrink(),
                    suggestionsCallback: (search) async {
                      if (isNullorEmpty(search) || _controller.isPagamentoDetalheSelected) {
                        return Future.value(const Iterable<AccountDto>.empty().toList());
                      }
                      var pagedResult = await Modular.get<IAccountRepository>().getAccounts(1, search);
                      var listAccount = pagedResult.data.map((e) => AccountDto.fromJson(e)).toList();
                      return Future.value(listAccount);
                    },
                    builder: (context, controller, focusNode) {
                      return Observer(builder: (_) {
                        return Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                enabled: !_controller.isPagamentoDetalheSelected,
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                controller: controller,
                                focusNode: focusNode,
                                autofocus: true,
                                decoration: InputDecoration(
                                  prefixText: '@',
                                  border: const OutlineInputBorder(),
                                  fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Theme.of(context).inputDecorationTheme.fillColor
                                      : Theme.of(context).scaffoldBackgroundColor,
                                  hintText: 'Usuário',
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                ),
                              ),
                            ),
                            _controller.isPagamentoDetalheSelected
                                ? IconButton(
                                    icon: const Icon(MdiIcons.closeOctagon),
                                    onPressed: () {
                                      _controller.clearPagamentoDetalhe();
                                    },
                                  )
                                : const SizedBox.shrink()
                          ],
                        );
                      });
                    },
                    itemBuilder: (context, data) {
                      return ListTile(
                        tileColor: Theme.of(context).cardTheme.color,
                        visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                        contentPadding: const EdgeInsets.all(0),
                        minLeadingWidth: 0,
                        leading: isNullorEmpty(data.fotoUrl)
                            ? CircleAvatar(
                                radius: 35,
                                backgroundColor: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black,
                                child: const CircleAvatar(
                                  radius: 21,
                                  backgroundImage: AssetImage('assets/person.png'),
                                ),
                              )
                            : CircleAvatar(
                                radius: 35,
                                backgroundColor: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.black,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgress(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  errorWidget: (context, url, error) {
                                    return const CircleAvatar(
                                      radius: 21,
                                      backgroundImage: AssetImage('assets/person.png'),
                                    );
                                  },
                                  imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/account/photo/${data.fotoUrl!}',
                                  imageBuilder: (context, imageProvider) {
                                    return CircleAvatar(
                                      radius: 21,
                                      backgroundImage: imageProvider,
                                    );
                                  },
                                ),
                              ),
                        title: Text(
                          data.username,
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          data.email,
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                      );
                    },
                    onSelected: (data) async {
                      await _controller.load(data.id, data.username);
                    },
                  ),
                ),
                Observer(builder: (_) {
                  if (!_controller.isPagamentoDetalheSelected) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            "Detalhes",
                            style: Theme.of(context).primaryTextTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Data e Hora",
                                style: Theme.of(context).primaryTextTheme.labelSmall,
                              ),
                              Text(
                                '${UtilData.obterDataDDMMAAAA(DateTime.now())} ${UtilData.obterHoraHHMM(DateTime.now())}',
                                style: Theme.of(context).primaryTextTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Sub-Total",
                              style: Theme.of(context).primaryTextTheme.labelSmall,
                            ),
                            Text(
                              UtilBrasilFields.obterReal(_controller.pagamentoDetalheDto!.total.toDouble()),
                              style: Theme.of(context).primaryTextTheme.labelSmall,
                            ),
                          ],
                        ),
                        const Divider(),
                        ListTile(
                          minVerticalPadding: 0,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          minLeadingWidth: 30,
                          contentPadding: const EdgeInsets.all(0),
                          leading: Text(
                            "Total",
                            style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                          ),
                          trailing: Text(
                            UtilBrasilFields.obterReal(_controller.pagamentoDetalheDto!.total.toDouble()),
                            style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Observer(builder: (_) {
                  if (!_controller.isPagamentoDetalheSelected) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TypeAheadField<int>(
                          controller: _controller.tipoPagamentoController,
                          emptyBuilder: (context) => const SizedBox.shrink(),
                          suggestionsCallback: (search) {
                            if (_controller.isTipoPagamentoSelected) {
                              return Future.value(const Iterable<int>.empty().toList());
                            }

                            return _controller.enumTipoPagamento.keys
                                .where((key) => _controller.enumTipoPagamento[key]!.toLowerCase().contains(search.toLowerCase()))
                                .toList();
                          },
                          builder: (context, controller, focusNode) {
                            return Observer(builder: (_) {
                              if (!_controller.isValidPagamento) {
                                return const SizedBox.shrink();
                              }

                              return Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      enabled: !_controller.isTipoPagamentoSelected,
                                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                                      controller: controller,
                                      focusNode: focusNode,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                            ? Theme.of(context).inputDecorationTheme.fillColor
                                            : Theme.of(context).scaffoldBackgroundColor,
                                        hintText: 'Tipo de pagamento',
                                        contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                      ),
                                    ),
                                  ),
                                  _controller.isTipoPagamentoSelected
                                      ? IconButton(
                                          icon: const Icon(MdiIcons.closeOctagon),
                                          onPressed: _controller.clearTipoPagamento,
                                        )
                                      : const SizedBox.shrink()
                                ],
                              );
                            });
                          },
                          itemBuilder: (context, data) {
                            return ListTile(
                              tileColor: Theme.of(context).cardTheme.color,
                              visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                              contentPadding: const EdgeInsets.all(0),
                              minLeadingWidth: 0,
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _controller.enumTipoPagamento[data]!,
                                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                                ),
                              ),
                            );
                          },
                          onSelected: (data) {
                            _controller.setTipoPagamento(data);
                          },
                        ),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          bottomNavigationBar: Observer(
            builder: (_) {
              if (!_controller.isValid) {
                return const SizedBox.shrink();
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              stops: const [0, .90],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 8,
                          ),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Observer(builder: (_) {
                            return TextButton(
                              onPressed: () async {
                                await _controller.realizarPagamento();
                              },
                              child: _controller.isLoadingRealizarPagamento
                                  ? const CircularProgress(
                                      width: 21,
                                      height: 21,
                                    )
                                  : const Text('Pagar'),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }
}
