import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/tab/home_page_controller.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:vilasesmo/app/stores/pagamentos_store.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_catalogo_repository.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/card_count_produto.dart';
import 'package:vilasesmo/app/utils/widgets/card_produto_color.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';
import 'package:vilasesmo/app/utils/widgets/refresh_widget.dart';

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
  Product({
    this.amount,
    this.description,
    this.discount,
    this.isFavourite,
    this.name,
    this.qty,
    this.rating,
    this.ratingCount,
    this.unitName,
    this.imagePath,
  });
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final controller = Modular.get<HomePageController>();
  final CarouselController _carouselController = CarouselController();
  final PagamentosStore pagamentosStore = Modular.get<PagamentosStore>();

  final List<String> _imagesList = ['assets/homescreen_banner.png', 'assets/Banner0.png', 'assets/Banner1.png'];

  List<Widget> _items() {
    List<Widget> list = [];
    for (int i = 0; i < _imagesList.length; i++) {
      list.add(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(
                _imagesList[i],
              ),
            )),
      ));
    }
    return list;
  }

  @override
  void initState() {
    Modular.get<PagamentosStore>().load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  //
                },
                horizontalTitleGap: 2,
                contentPadding: const EdgeInsets.all(0),
                leading: Modular.get<ThemeStore>().isDarkModeEnable
                    ? Image.asset(
                        'assets/google_dark.png',
                        height: 60,
                        width: 30,
                      )
                    : Image.asset(
                        'assets/google_light.png',
                        height: 60,
                        width: 30,
                      ),
                title: Text(greetingMessage(), style: Theme.of(context).primaryTextTheme.bodyLarge),
                subtitle: Text('@${Modular.get<AccountStore>().account!.nome}',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .displayMedium!
                        .copyWith(fontWeight: FontWeight.w300, fontFamily: 'PoppinsLight')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Modular.to.pushNamed('/notificacoes/');
                      },
                      icon: Modular.get<ThemeStore>().isDarkModeEnable
                          ? Image.asset('assets/notificationIcon_white.png')
                          : Image.asset('assets/notificationIcon_black.png'),
                    ),
                    Observer(builder: (_) {
                      var pagamentoDetalheDtoIsNull = pagamentosStore.pagamentoDetalheDto == null;

                      if (pagamentoDetalheDtoIsNull) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFFF05656), borderRadius: BorderRadius.all(Radius.circular(6))),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        width: 84,
                        height: 30,
                        child: Row(
                          children: [
                            const Icon(
                              MdiIcons.currencyBrl,
                              color: Colors.white,
                              size: 20,
                            ),
                            pagamentosStore.isLoading
                                ? const Expanded(
                                    child: CircularProgress(
                                      color: Colors.white,
                                      width: 15,
                                      height: 15,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      ' ${pagamentosStore.pagamentoDetalheDto!.total}',
                                      style: Theme.of(context).primaryTextTheme.bodySmall,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Observer(builder: (_) {
                  return CarouselSlider(
                    items: _items(),
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      viewportFraction: 0.99,
                      initialPage: controller.currentIndexCarouselSlider,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, _) {
                        controller.currentIndexCarouselSlider = index;
                      },
                    ),
                  );
                }),
              ),
              Observer(builder: (_) {
                return DotsIndicator(
                  dotsCount: _imagesList.length,
                  position: controller.currentIndexCarouselSlider.toDouble(),
                  onTap: (i) {
                    controller.currentIndexCarouselSlider = i.toInt();
                    _carouselController.animateToPage(controller.currentIndexCarouselSlider,
                        duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                  },
                  decorator: DotsDecorator(
                    activeSize: const Size(6, 6),
                    size: const Size(6, 6),
                    activeShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                    activeColor: Theme.of(context).primaryColor,
                    color: Modular.get<ThemeStore>().isDarkModeEnable ? Colors.white : Colors.grey,
                  ),
                );
              }),
              Observer(
                builder: (_) {
                  return controller.isVisibleNovos
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Novos',
                                style: Theme.of(context).primaryTextTheme.headlineSmall,
                              ),
                              InkWell(
                                onTap: () {
                                  Modular.to.pushNamed('/search/');
                                },
                                child: Text(
                                  'todos',
                                  style: Theme.of(context).primaryTextTheme.displayLarge,
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
              Observer(builder: (_) {
                return listaNovos();
              }),
              Observer(builder: (_) {
                return controller.isVisibleFavoritos
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Favoritos',
                              style: Theme.of(context).primaryTextTheme.headlineSmall,
                            ),
                            InkWell(
                              onTap: () {
                                Modular.to.pushNamed('/search/');
                              },
                              child: Text(
                                'todos',
                                style: Theme.of(context).primaryTextTheme.displayLarge,
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              listaFavoritos(),
              Observer(
                builder: (_) {
                  return controller.isVisibleMaisVendidos
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mais vendidos',
                                style: Theme.of(context).primaryTextTheme.headlineSmall,
                              ),
                              InkWell(
                                onTap: () {
                                  Modular.to.pushNamed('/search/');
                                },
                                child: Text(
                                  'todos',
                                  style: Theme.of(context).primaryTextTheme.displayLarge,
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
              listaMaisVendidos(),
              Observer(builder: (_) {
                return controller.isVisibleUltimosVendidos
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Últimos vendidos',
                              style: Theme.of(context).primaryTextTheme.headlineSmall,
                            ),
                            InkWell(
                              onTap: () {
                                Modular.to.pushNamed('/search/');
                              },
                              child: Text(
                                'todos',
                                style: Theme.of(context).primaryTextTheme.displayLarge,
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              listaUltimosVendidos(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _errorList(BuildContext context, Function()? refresh) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
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
            height: 50,
            child: GestureDetector(
              onTap: refresh,
              child: Icon(
                Icons.refresh,
                size: 50,
                color: Theme.of(context).primaryTextTheme.displaySmall!.color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget listaNovos() {
    return SizedBox(
      height: controller.isVisibleNovos ? 200 : 500,
      child: InfiniteList<CatalogoDto>(
        noMoreItemsBuilder: const SizedBox.shrink(),
        scrollDirection: Axis.horizontal,
        pagingController: controller.pagingNovosController,
        request: (page) async {
          return await Modular.get<ICatalogoRepository>().getProdutosNovos(page);
        },
        itemBuilder: (context, item, index) {
          controller.isVisibleNovos = true;

          return SizedBox(
            height: 200,
            child: InkWell(
              onTap: () async {
                await Modular.to.pushNamed('/produtos/details/${item.produtoId}');
              },
              child: Container(
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
                                item.nome,
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                              ),
                              Text(
                                item.getDisponiveis(),
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
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Theme.of(context).primaryTextTheme.displayMedium!.color),
                                      ),
                                      Text(
                                        '${item.preco}',
                                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                                      )
                                    ],
                                  ),
                                  InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      onTap: () {
                                        //
                                      },
                                      child: Image.asset('assets/orange_next.png')),
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
                        imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${item.imageUrl}',
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
            ),
          );
        },
        cast: CatalogoDto.fromJson,
        emptyBuilder: (context) {
          controller.isVisibleNovos = false;
          return RefreshWidget(
            onTap: () {
              controller.pagingNovosController.refresh();
            },
          );
        },
        errorBuilder: (context) {
          return _errorList(context, () {
            controller.pagingNovosController.refresh();
          });
        },
      ),
    );
  }

  Widget listaMaisVendidos() {
    return SizedBox(
      height: 210,
      child: InfiniteList<CatalogoDto>(
        noMoreItemsBuilder: const SizedBox.shrink(),
        scrollDirection: Axis.horizontal,
        pagingController: controller.pagingMaisVendidosController,
        request: (page) async {
          return await Modular.get<ICatalogoRepository>().getProdutosMaisVendidos(page);
        },
        itemBuilder: (context, item, index) {
          controller.isVisibleMaisVendidos = true;

          return CardProdutoColor(
            item,
            index: index,
          );
        },
        cast: CatalogoDto.fromJson,
        emptyBuilder: (context) {
          controller.isVisibleMaisVendidos = false;
          return const SizedBox.shrink();
        },
        errorBuilder: (context) {
          return _errorList(context, () {
            controller.pagingMaisVendidosController.refresh();
          });
        },
      ),
    );
  }

  Widget listaFavoritos() {
    return SizedBox(
      height: 135,
      child: SizedBox(
        height: 210,
        child: InfiniteList<CatalogoDto>(
          noMoreItemsBuilder: const SizedBox.shrink(),
          scrollDirection: Axis.horizontal,
          pagingController: controller.pagingFavoritosController,
          request: (page) async {
            return await Modular.get<ICatalogoRepository>().getProdutosFavoritos(page);
          },
          itemBuilder: (context, item, index) {
            controller.isVisibleFavoritos = true;

            return SizedBox(
              height: 200,
              child: InkWell(
                onTap: () async {
                  await Modular.to.pushNamed('/produtos/details/${item.produtoId}');
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 105,
                        width: 180,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(17),
                              bottomLeft: Radius.circular(17),
                              bottomRight: Radius.circular(17),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 28, left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item.nome,
                                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                                ),
                                Container(
                                  width: 130,
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "R\$ ",
                                            style: Theme.of(context).primaryTextTheme.displayMedium,
                                          ),
                                          Text(
                                            '${item.preco} ',
                                            style: Theme.of(context).primaryTextTheme.headlineSmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.getDisponiveis(),
                                  style: Theme.of(context).primaryTextTheme.displayMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        left: null,
                        top: 30,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            height: 100,
                            width: 98,
                            child: CircularProgress(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          errorWidget: (context, url, error) => const SizedBox(
                            height: 100,
                            width: 98,
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
                          imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${item.imageUrl}',
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                ),
                              ),
                              height: 100,
                              width: 98,
                            );
                          },
                        ),
                      ),
                      Observer(builder: (_) {
                        return CardCountProduto(
                          produtoId: item.produtoId,
                          estoqueDisponivel: item.estoque,
                          isAtivo: item.isAtivo,
                          isTop: true,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
          cast: CatalogoDto.fromJson,
          emptyBuilder: (context) {
            controller.isVisibleFavoritos = false;
            return const SizedBox.shrink();
          },
          errorBuilder: (context) {
            return _errorList(context, () {
              controller.pagingFavoritosController.refresh();
            });
          },
        ),
      ),
    );
  }

  Widget listaUltimosVendidos() {
    return SizedBox(
      height: 210,
      child: InfiniteList<CatalogoDto>(
        noMoreItemsBuilder: const SizedBox.shrink(),
        scrollDirection: Axis.horizontal,
        pagingController: controller.pagingUltimosVendidosController,
        request: (page) async {
          return await Modular.get<ICatalogoRepository>().getProdutosUltimosVendidos(page);
        },
        itemBuilder: (context, item, index) {
          controller.isVisibleUltimosVendidos = true;

          return CardProdutoColor(
            item,
            index: index,
          );
        },
        cast: CatalogoDto.fromJson,
        emptyBuilder: (context) {
          controller.isVisibleUltimosVendidos = false;
          return const SizedBox.shrink();
        },
        errorBuilder: (context) {
          return _errorList(context, () {
            controller.pagingUltimosVendidosController.refresh();
          });
        },
      ),
    );
  }
}
