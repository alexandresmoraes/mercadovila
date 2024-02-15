import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/modules/compras/carrinho_compras_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/widgets/card_produto_carrinho_compras.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class CarrinhoPage extends StatefulWidget {
  final String title;
  const CarrinhoPage({Key? key, this.title = 'Compra'}) : super(key: key);
  @override
  CarrinhoPageState createState() => CarrinhoPageState();
}

class CarrinhoPageState extends State<CarrinhoPage> {
  final carrinhoComprasStore = Modular.get<CarrinhoComprasStore>();

  List<String> orderProcess = ['Carrinho', 'Pagamento'];

  int _currentIndex = 0;
  PageController? _pageController;
  ScrollController? _scrollController;
  bool step1Done = false;
  bool step2Done = false;

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

    carrinhoComprasStore.load();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Modular.to.pop();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.title),
            leading: IconButton(
              onPressed: () {
                if (_currentIndex == 0) {
                  Modular.to.pop();
                } else {
                  _pageController!.animateToPage(_currentIndex - 1,
                      duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
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
            automaticallyImplyLeading: _currentIndex == 0,
            actions: [
              IconButton(
                onPressed: () async {
                  adicionarItemModalShow();
                },
                icon: const Icon(MdiIcons.plus),
              ),
            ],
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
                                          border: Border.all(
                                              color: _currentIndex == i ? Colors.black : const Color(0xFF505266),
                                              width: 1.5),
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
                                            color:
                                                _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
                                            border: Border.all(
                                              color: _currentIndex >= i
                                                  ? const Color(0xFF4A4352)
                                                  : const Color(0xFFBcc8d2),
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
                                          color: Colors.white,
                                          border: Border.all(
                                              color: _currentIndex >= i
                                                  ? const Color(0xFF4A4352)
                                                  : const Color(0xFFBcc8d2),
                                              width: 1.5),
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
                    _scrollController!
                        .animateTo(currentIndex, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
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
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        gradient: carrinhoComprasStore.isLoading
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
                          if (carrinhoComprasStore.isLoading) return;

                          if (_currentIndex == 0) {
                            _pageController!.animateToPage(_currentIndex + 1,
                                duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                          } else if (_currentIndex == 1) {
                            //
                          }
                        },
                        child: Text(
                          carrinhoComprasStore.isLoading
                              ? 'Aguarde..'
                              : _currentIndex == 0
                                  ? 'Ir para detalhes'
                                  : 'Comprar',
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

  Widget _carrinho() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Observer(builder: (_) {
              if (carrinhoComprasStore.carrinhoComprasItens.isEmpty) {
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
                itemCount: carrinhoComprasStore.carrinhoComprasItens.length,
                itemBuilder: (_, index) {
                  final item = carrinhoComprasStore.carrinhoComprasItens[index];

                  return Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.15,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) => CupertinoActionSheet(
                                title: const Icon(Icons.question_answer),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    isDestructiveAction: true,
                                    onPressed: () async {
                                      Modular.to.pop();
                                      await Modular.get<CarrinhoStore>()
                                          .removerCarrinhoItem(item.produtoId, item.quantidade);
                                    },
                                    child: const Text(
                                      'Remover',
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Modular.to.pop();
                                    },
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.red,
                          icon: MdiIcons.trashCanOutline,
                        ),
                      ],
                    ),
                    child: CardProdutoCarrinhoCompras(item: item),
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
                  "Subtotal",
                  style: Theme.of(context).primaryTextTheme.labelSmall,
                ),
                Observer(builder: (_) {
                  return Text(
                    "R\$ ${carrinhoComprasStore.carrinhoComprasDto!.total}",
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
                  "R\$ ${carrinhoComprasStore.carrinhoComprasDto!.subtotal}",
                  style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagamento() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 8,
          left: 8,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Observer(builder: (_) {
              return Container(
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
                      "Detalhes",
                      style: TextStyle(
                          fontSize: 14,
                          color: Modular.get<ThemeStore>().isDarkModeEnable
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Data e Hora",
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  ),
                  Text(
                    "26/03/2021 12:40 PM",
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
                    "R\$ ${carrinhoComprasStore.carrinhoComprasDto?.total}",
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
                    "R\$ ${carrinhoComprasStore.carrinhoComprasDto?.subtotal}",
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

  void adicionarItemModalShow() {
    WoltModalSheet.show<void>(
      // pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilder: (modalSheetContext) {
        final textTheme = Theme.of(context).primaryTextTheme;
        return [
          WoltModalSheetPage(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            hasSabGradient: false,
            stickyActionBar: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
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
                  // TODO
                  Modular.to.pop();
                },
                child: const Text(
                  'Adicionar',
                ),
              ),
            ),
            topBarTitle: Text(
              'Adicionar item',
              style: textTheme.titleLarge,
            ),
            isTopBarLayerAlwaysVisible: true,
            trailingNavBarWidget: IconButton(
              padding: const EdgeInsets.all(16),
              icon: const Icon(Icons.close),
              onPressed: () => Modular.to.pop(),
            ),
            child: const Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  300,
                ),
                child: Text(
                  '''
Pagination involves a sequence of screens the user navigates sequentially. We chose a lateral motion for these transitions. When proceeding forward, the next screen emerges from the right; moving backward, the screen reverts to its original position. We felt that sliding the next screen entirely from the right could be overly distracting. As a result, we decided to move and fade in the next page using 30% of the modal side.
''',
                )),
          ),
        ];
      },
      modalTypeBuilder: (context) {
        final size = MediaQuery.of(context).size.width;
        if (size < 768) {
          return WoltModalType.bottomSheet;
        } else {
          return WoltModalType.dialog;
        }
      },
      onModalDismissedWithBarrierTap: () {
        debugPrint('Closed modal sheet with barrier tap');
        Modular.to.pop();
      },
      maxDialogWidth: 560,
      minDialogWidth: 400,
      minPageHeight: 0.0,
      maxPageHeight: 0.9,
    );
  }
}
