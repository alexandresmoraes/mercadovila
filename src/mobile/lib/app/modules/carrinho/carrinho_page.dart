import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/carrinho/carrinho_dto.dart';
import 'package:vilasesmo/app/utils/widgets/card_produto_carrinho.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/future_triple.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';
import 'package:vilasesmo/app/utils/widgets/refresh_widget.dart';

class CarrinhoPage extends StatefulWidget {
  final String title;
  const CarrinhoPage({Key? key, this.title = 'Carrinho'}) : super(key: key);
  @override
  CarrinhoPageState createState() => CarrinhoPageState();
}

class CarrinhoPageState extends State<CarrinhoPage> {
  final carrinhoStore = Modular.get<CarrinhoStore>();

  GlobalKey<ScaffoldState>? _scaffoldKey;

  int _currentIndex = 0;
  PageController? _pageController;
  ScrollController? _scrollController;
  bool step1Done = false;
  bool step2Done = false;

  CarrinhoPageState() : super();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(initialScrollOffset: _currentIndex.toDouble());
    _pageController = PageController(initialPage: _currentIndex);
    _pageController!.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<String> orderProcess = ['Carrinho', 'Pagamento'];

    return WillPopScope(
      onWillPop: () async {
        Modular.to.pop();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              orderProcess[_currentIndex],
            ),
            actions: [
              !kIsWeb && (Platform.isAndroid || Platform.isIOS)
                  ? IconButton(
                      icon: Icon(
                        MdiIcons.barcode,
                        color: !Modular.get<ThemeStore>().isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                      ),
                      onPressed: () async {
                        Modular.to.pushNamed('/carrinho/scanner');
                      },
                    )
                  : const SizedBox.shrink(),
            ],
            leading: IconButton(
              onPressed: () {
                if (_currentIndex == 0) {
                  Modular.to.pop();
                } else {
                  _pageController!.animateToPage(_currentIndex - 1, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                  if (_currentIndex == 0) {
                    step1Done = false;
                  } else if (_currentIndex == 1) {
                    step2Done = false;
                  }

                  setState(() {});
                }
              },
              icon: const Icon(MdiIcons.arrowLeft),
            ),
            automaticallyImplyLeading: _currentIndex == 0 ? true : false,
          ),
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 20,
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 10),
                child: Center(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: orderProcess.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int i) {
                        return Modular.get<ThemeStore>().isDarkModeEnable
                            ? Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: _currentIndex >= i ? Colors.black : const Color(0xFF505266),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.5,
                                            ),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(left: 25, right: 10),
                                          child: Text(
                                            orderProcess[i],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          )),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: _currentIndex >= i ? Colors.white : Colors.black,
                                          border: Border.all(color: _currentIndex == i ? Colors.black : const Color(0xFF505266), width: 1.5),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: _currentIndex >= i ? Colors.black : const Color(0xFF505266),
                                        ),
                                      ),
                                    ],
                                  ),
                                  i == 1
                                      ? const SizedBox()
                                      : Container(
                                          height: 2,
                                          color: _currentIndex <= i ? const Color(0xFF505266) : Colors.black,
                                          width: 20,
                                          margin: const EdgeInsets.all(0),
                                        ),
                                ],
                              )
                            : Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
                                          border: Border.all(
                                            color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
                                            width: 1.5,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(left: 25, right: 10),
                                        child: Text(
                                          orderProcess[i],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2), width: 1.5),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
                                        ),
                                      ),
                                    ],
                                  ),
                                  i == 1
                                      ? const SizedBox()
                                      : Container(
                                          height: 2,
                                          color: _currentIndex <= i ? const Color(0xFFBcc8d2) : const Color(0xFF4A4352),
                                          width: 20,
                                          margin: const EdgeInsets.all(0),
                                        ),
                                ],
                              );
                      }),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _currentIndex = index;
                    double currentIndex = _currentIndex.toDouble();
                    _scrollController!.animateTo(currentIndex, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                    setState(() {});
                  },
                  children: [
                    _carrinho(),
                    _pagamento(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Observer(
            builder: (_) {
              if (!carrinhoStore.isValidCarrinho) {
                return const SizedBox.shrink();
              }

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        gradient: carrinhoStore.isLoading
                            ? LinearGradient(
                                stops: const [0, .90],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Theme.of(context).primaryColorLight, Theme.of(context).iconTheme.color!],
                              )
                            : LinearGradient(
                                stops: const [0, .90],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                              ),
                      ),
                      margin: const EdgeInsets.all(8.0),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: () async {
                          if (carrinhoStore.isLoading) return;

                          if (_currentIndex == 0) {
                            _pageController!.animateToPage(_currentIndex + 1, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                          } else if (_currentIndex == 1) {
                            await carrinhoStore.criarVenda();
                          }
                        },
                        child: Text(
                          carrinhoStore.isLoading
                              ? 'Aguarde..'
                              : _currentIndex == 0
                                  ? 'Ir para o pagamento'
                                  : 'Pagar',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool isLoaded = false;

  void checkIndisponiveis() {
    for (var item in carrinhoStore.carrinhoDto!.itens) {
      if (item.quantidade > item.estoque || !item.isDisponivel()) {
        GlobalSnackbar.error('Identifique os itens indisponíveis');
        break;
      }
    }
  }

  Future<CarrinhoDto> load() async {
    if (isLoaded) {
      checkIndisponiveis();
      return carrinhoStore.carrinhoDto!;
    }

    await carrinhoStore.load();
    checkIndisponiveis();
    isLoaded = true;
    return carrinhoStore.carrinhoDto!;
  }

  Widget _carrinho() {
    return FutureTriple(
      future: load(),
      data: (_, snapshot) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Observer(builder: (_) {
                  if (carrinhoStore.carrinhoItens.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/empty_cart.png',
                            width: 300,
                            height: 300,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: carrinhoStore.carrinhoItens.length,
                    itemBuilder: (_, index) {
                      final item = carrinhoStore.carrinhoItens[index];

                      return Slidable(
                        key: Key(item.produtoId),
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          dismissible: DismissiblePane(
                            closeOnCancel: true,
                            confirmDismiss: () {
                              return remover(item.produtoId, item.quantidade);
                            },
                            onDismissed: () {},
                          ),
                          children: [
                            SlidableAction(
                              label: 'Remover?',
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.red,
                              icon: MdiIcons.trashCanOutline,
                              onPressed: (_) {
                                remover(item.produtoId, item.quantidade);
                              },
                            ),
                          ],
                        ),
                        child: CardProdutoCarrinho(item),
                      );
                    },
                  );
                }),
                ListTile(
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    "Preço",
                    style: Theme.of(context).primaryTextTheme.headlineSmall,
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
                    Observer(builder: (_) {
                      return Text(
                        UtilBrasilFields.obterReal(carrinhoStore.carrinhoDto!.total.toDouble()),
                        style: Theme.of(context).primaryTextTheme.labelSmall,
                      );
                    }),
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
                  trailing: Observer(builder: (_) {
                    return Text(
                      UtilBrasilFields.obterReal(carrinhoStore.carrinhoDto!.subtotal.toDouble()),
                      style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                    );
                  }),
                ),
                Modular.get<ThemeStore>().isDarkModeEnable
                    ? Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/checkout_cart_dark.png',
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                    : Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/checkout_cart_light.png',
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
              ],
            ),
          ),
        );
      },
      error: RefreshWidget(
        onTap: () => setState(() {}),
      ),
      loading: const CircularProgress(),
    );
  }

  Widget _pagamento() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Observer(builder: (_) {
              return !carrinhoStore.isDescontoSalario && !carrinhoStore.isDinheiro
                  ? Container(
                      padding: const EdgeInsets.all(2),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Selecione a opção de pagamento",
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    Modular.get<ThemeStore>().isDarkModeEnable ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          )),
                    )
                  : const SizedBox.shrink();
            }),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 7,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Opções de pagamento',
                  style: Theme.of(context).primaryTextTheme.headlineSmall,
                ),
              ),
            ),
            Observer(builder: (_) {
              return InkWell(
                onTap: () {
                  carrinhoStore.setDescontoSalario();
                },
                child: ListTile(
                  leading: Radio(
                    value: true,
                    groupValue: carrinhoStore.isDescontoSalario,
                    onChanged: (value) {},
                  ),
                  title: Text(
                    "Desconto em folha",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    "Solicitar autorização para desconto em folha no próximo mês útil.",
                    style: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                  trailing: Icon(
                    Icons.account_balance,
                    color: !Modular.get<ThemeStore>().isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                  ),
                ),
              );
            }),
            Observer(builder: (_) {
              return InkWell(
                onTap: () {
                  carrinhoStore.setDinheiro();
                },
                child: ListTile(
                  leading: Radio(
                    value: true,
                    groupValue: carrinhoStore.isDinheiro,
                    onChanged: (value) {},
                  ),
                  title: Text(
                    "Dinheiro",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    "Por favor, deposite seu dinheiro na caixa correspondente.",
                    style: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                  trailing: Icon(
                    MdiIcons.cash,
                    color: !Modular.get<ThemeStore>().isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                  ),
                ),
              );
            }),
            const Divider(),
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
                Observer(builder: (_) {
                  return Text(
                    UtilBrasilFields.obterReal(carrinhoStore.carrinhoDto?.total.toDouble() ?? 0),
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  );
                }),
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
              trailing: Observer(
                builder: (_) {
                  return Text(
                    UtilBrasilFields.obterReal(carrinhoStore.carrinhoDto?.subtotal.toDouble() ?? 0),
                    style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> remover(String produtoId, int quantidade) async {
    return await showCupertinoModalPopup<bool>(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            title: const Icon(Icons.question_answer),
            actions: <Widget>[
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () async {
                  Modular.to.pop(true);
                  await Modular.get<CarrinhoStore>().removerCarrinhoItem(produtoId, quantidade);
                },
                child: const Text(
                  'Sim',
                ),
              ),
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  Modular.to.pop(false);
                },
                child: const Text(
                  'Não',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
