import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/widgets/card_produto_carrinho.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';

class CarrinhoPage extends StatefulWidget {
  final String title;
  const CarrinhoPage({Key? key, this.title = 'Carrinho'}) : super(key: key);
  @override
  CarrinhoPageState createState() => CarrinhoPageState();
}

class Product {
  String? name;
  int? qty;
  bool? isFavourite = false;
  String? rating;
  String? amount;
  String? unitName;
  String? ratingCount;
  String? description;
  String? discount;
  String? imagePath;
  Product(
      {this.amount,
      this.description,
      this.discount,
      this.isFavourite,
      this.name,
      this.qty,
      this.rating,
      this.ratingCount,
      this.unitName,
      this.imagePath});
}

class Address {
  String? title;
  String? address;
  Address({this.title, this.address});
}

class CarrinhoPageState extends State<CarrinhoPage> {
  final carrinhoStore = Modular.get<CarrinhoStore>();

  GlobalKey<ScaffoldState>? _scaffoldKey;

  String? selectedCouponCode;
  int? vendorId;
  String selectedTimeSlot = '';
  String? barberName;
  int _currentIndex = 0;
  int? selectedCoupon;
  PageController? _pageController;
  ScrollController? _scrollController;
  DateTime? selectedDate;
  bool step1Done = false;
  bool step2Done = false;
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();

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

    carrinhoStore.load();
  }

  @override
  Widget build(BuildContext context) {
    List<String> orderProcess = ['Carrinho', 'Pagamento'];
    List<String> orderProcessText = ['Carrinho', 'Pagamento'];

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
              orderProcessText[_currentIndex],
            ),
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
                icon: const Icon(MdiIcons.arrowLeft)),
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
                                          color: _currentIndex >= i ? Colors.black : const Color(0xFF505266),
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
                                          )),
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
                                  i == 3
                                      ? const SizedBox()
                                      : Container(
                                          height: 2,
                                          color: _currentIndex >= i ? const Color(0xFF4A4352) : const Color(0xFFBcc8d2),
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
                    _cartWidget(),
                    _payment(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Row(
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
                  margin: const EdgeInsets.all(8.0),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                      onPressed: () {
                        if (_currentIndex == 3) {
                          //
                        } else {
                          _pageController!.animateToPage(_currentIndex + 1, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                        }
                      },
                      child: Text(
                        _currentIndex == 0 ? 'Checkout' : 'Pagamento',
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartWidget() {
    return Observer(builder: (_) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: carrinhoStore.isLoading
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgress(),
                    ],
                  )
                : Column(
                    children: [
                      Observer(builder: (_) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: carrinhoStore.carrinhoItens.length,
                          itemBuilder: (_, index) {
                            var item = carrinhoStore.carrinhoItens[index];
                            return CardProdutoCarrinho(item);
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
                          Text(
                            "R\$ ${carrinhoStore.carrinhoDto!.total}",
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
                          "R\$ ${carrinhoStore.carrinhoDto!.subtotal}",
                          style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                        ),
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
        ),
      );
    });
  }

  Widget _payment() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  carrinhoStore.setSelectOpcaoPagamento(true);
                },
                child: ListTile(
                  leading: Radio(
                    value: true,
                    groupValue: carrinhoStore.selectOpcaoPagamento,
                    onChanged: (value) {
                      carrinhoStore.setSelectOpcaoPagamento(value!);
                    },
                  ),
                  title: Text(
                    "Desconto em folha",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    "Autorizar o desconto em folha no próximo mês útil",
                    style: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                  trailing: Image.asset(
                    'assets/dinheiro.png',
                    scale: 1.5,
                  ),
                ),
              );
            }),
            Observer(builder: (_) {
              return !carrinhoStore.selectOpcaoPagamento
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
              padding: const EdgeInsets.only(top: 10.0),
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
            ListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                "Detalhes",
                style: Theme.of(context).primaryTextTheme.headlineSmall,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total",
                  style: Theme.of(context).primaryTextTheme.labelSmall,
                ),
                Text(
                  "R\$ 80.62",
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
                "R\$ 61.27",
                style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
