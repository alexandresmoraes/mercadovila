import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/modules/tab/home_page_controller.dart';
import 'package:mercadovila/app/stores/account_store.dart';
import 'package:mercadovila/app/stores/pagamentos_store.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_catalogo_repository.dart';
import 'package:mercadovila/app/utils/utils.dart';
import 'package:mercadovila/app/utils/widgets/card_count_produto.dart';
import 'package:mercadovila/app/utils/widgets/card_produto_color.dart';
import 'package:mercadovila/app/utils/widgets/circular_progress.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';
import 'package:mercadovila/app/utils/widgets/refresh_widget.dart';

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

  final List<String> _imagesList = ['assets/Banner0.png', 'assets/Banner1.png', 'assets/Banner2.png'];

  List<Widget> _items() {
    List<Widget> list = [];
    for (int i = 0; i < _imagesList.length; i++) {
      list.add(ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          _imagesList[i],
          fit: BoxFit.cover,
        ),
      ));
    }
    return list;
  }

  @override
  void initState() {
    pagamentosStore.load();

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
                onTap: () {},
                horizontalTitleGap: 2,
                contentPadding: const EdgeInsets.all(0),
                leading: Observer(builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: isNullorEmpty(Modular.get<AccountStore>().account!.fotoUrl)
                        ? CircleAvatar(
                            radius: 25,
                            backgroundColor: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                            child: const CircleAvatar(
                              radius: 23,
                              backgroundImage: AssetImage('assets/person.png'),
                            ),
                          )
                        : CircleAvatar(
                            radius: 25,
                            backgroundColor: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => CircularProgress(
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorWidget: (context, url, error) {
                                return const CircleAvatar(
                                  radius: 23,
                                  backgroundImage: AssetImage('assets/person.png'),
                                );
                              },
                              imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/account/photo/${Modular.get<AccountStore>().account!.fotoUrl!}',
                              imageBuilder: (context, imageProvider) {
                                return CircleAvatar(
                                  radius: 23,
                                  backgroundImage: imageProvider,
                                );
                              },
                            ),
                          ),
                  );
                }),
                title: Text(greetingMessage(), style: Theme.of(context).primaryTextTheme.bodyLarge),
                subtitle: Text('@${Modular.get<AccountStore>().account!.nome}',
                    style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(fontWeight: FontWeight.w300, fontFamily: 'PoppinsLight')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Observer(builder: (_) {
                      var pagamentoDetalheDtoIsNull = pagamentosStore.pagamentoDetalheDto == null;

                      if (pagamentoDetalheDtoIsNull) {
                        return const SizedBox.shrink();
                      }

                      return AnimatedOpacity(
                        opacity: pagamentosStore.isLoading ? 0 : 1,
                        duration: const Duration(milliseconds: 2000),
                        child: Container(
                          decoration: const BoxDecoration(color: Color(0xFFF05656), borderRadius: BorderRadius.all(Radius.circular(6))),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  UtilBrasilFields.obterReal(pagamentosStore.pagamentoDetalheDto!.total.toDouble(), moeda: false),
                                  style: Theme.of(context).primaryTextTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: () {
                        Modular.to.pushNamed('/notificacoes/');
                      },
                      icon: Modular.get<ThemeStore>().isDarkModeEnable
                          ? Image.asset('assets/notificationIcon_white.png')
                          : Image.asset('assets/notificationIcon_black.png'),
                    ),
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
              Observer(
                builder: (_) {
                  return controller.isUltimosVendidosEmpty ? const SizedBox.shrink() : listaUltimosVendidos();
                },
              ),
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
              Observer(
                builder: (_) {
                  return controller.isFavoritosEmpty ? const SizedBox.shrink() : listaFavoritos();
                },
              ),
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
              Observer(
                builder: (_) {
                  return controller.isMaisVendidosEmpty ? const SizedBox.shrink() : listaMaisVendidos();
                },
              ),
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
          var produtosNovos = await Modular.get<ICatalogoRepository>().getProdutosNovos(page);
          return produtosNovos;
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
                                        style: TextStyle(fontSize: 10, color: Theme.of(context).primaryTextTheme.displayMedium!.color),
                                      ),
                                      Text(
                                        UtilBrasilFields.obterReal(item.preco.toDouble(), moeda: false),
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
      height: controller.isVisibleMaisVendidos ? 210 : 0,
      child: InfiniteList<CatalogoDto>(
        noMoreItemsBuilder: const SizedBox.shrink(),
        scrollDirection: Axis.horizontal,
        pagingController: controller.pagingMaisVendidosController,
        request: (page) async {
          var maisVendidos = await Modular.get<ICatalogoRepository>().getProdutosMaisVendidos(page);
          controller.isMaisVendidosEmpty = maisVendidos.total == 0;
          return maisVendidos;
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
      height: controller.isVisibleFavoritos ? 135 : 0,
      child: SizedBox(
        height: controller.isVisibleFavoritos ? 210 : 0,
        child: InfiniteList<CatalogoDto>(
          noMoreItemsBuilder: const SizedBox.shrink(),
          scrollDirection: Axis.horizontal,
          pagingController: controller.pagingFavoritosController,
          request: (page) async {
            var favoritos = await Modular.get<ICatalogoRepository>().getProdutosFavoritos(page);
            controller.isFavoritosEmpty = favoritos.total == 0;
            return favoritos;
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
                                            UtilBrasilFields.obterReal(item.preco.toDouble(), moeda: false),
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
      height: controller.isVisibleUltimosVendidos ? 210 : 0,
      child: InfiniteList<CatalogoDto>(
        noMoreItemsBuilder: const SizedBox.shrink(),
        scrollDirection: Axis.horizontal,
        pagingController: controller.pagingUltimosVendidosController,
        request: (page) async {
          var ultimosVendidos = await Modular.get<ICatalogoRepository>().getProdutosUltimosVendidos(page);
          controller.isUltimosVendidosEmpty = ultimosVendidos.total == 0;
          return ultimosVendidos;
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
