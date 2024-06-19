import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/modules/produtos/produtos_detail_controller.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:mercadovila/app/utils/dto/catalogo/catalogo_dto.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_catalogo_repository.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_favoritos_repository.dart';
import 'package:mercadovila/app/utils/widgets/card_count_produto.dart';
import 'package:mercadovila/app/utils/widgets/circular_progress.dart';
import 'package:mercadovila/app/utils/widgets/future_triple.dart';
import 'package:mercadovila/app/utils/widgets/infinite_list.dart';
import 'package:mercadovila/app/utils/widgets/refresh_widget.dart';
import 'package:shimmer/shimmer.dart';

class ProdutosDetailPage extends StatefulWidget {
  final String title;
  final String id;
  const ProdutosDetailPage({Key? key, this.title = 'Detalhes do produto', required this.id}) : super(key: key);
  @override
  ProdutosDetailPageState createState() => ProdutosDetailPageState();
}

class ProdutosDetailPageState extends State<ProdutosDetailPage> {
  ProdutosDetailPageState() : super();

  final ProdutosDetailController _controller = Modular.get<ProdutosDetailController>();
  PagingController<int, CatalogoDto> pagingFavoritosController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Detalhes do produto"),
      ),
      body: FutureTriple(
        future: _controller.load(),
        error: RefreshWidget(
          onTap: () => setState(() {}),
        ),
        loading: const CircularProgress(),
        data: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 350,
                  margin: const EdgeInsets.only(top: 25),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: Modular.get<ThemeStore>().isDarkModeEnable
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  stops: const [0, .90],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [const Color(0xFF545975).withOpacity(0.44), const Color(0xFF333550).withOpacity(0.22)],
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              )
                            : BoxDecoration(
                                gradient: LinearGradient(
                                  stops: const [0, .90],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [const Color(0xFFA6C1D6).withOpacity(0.07), const Color(0xFF7C96AA).withOpacity(0.33)],
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 75),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.nome,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  snapshot.data!.descricao,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).primaryTextTheme.labelLarge,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "R\$ ",
                                            style: Theme.of(context).primaryTextTheme.displayMedium,
                                            children: [
                                              TextSpan(
                                                text: UtilBrasilFields.obterReal(snapshot.data!.preco, moeda: false),
                                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                              ),
                                              TextSpan(
                                                text: ' / ${snapshot.data!.unidadeMedida}',
                                                style: Theme.of(context).primaryTextTheme.displayMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 18,
                                          color: Theme.of(context).primaryColorLight,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: "${UtilBrasilFields.obterReal(snapshot.data!.rating.toDouble(), moeda: false, decimal: 1)} ",
                                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                                            children: [
                                              TextSpan(
                                                text: '|',
                                                style: Theme.of(context).primaryTextTheme.displayMedium,
                                              ),
                                              TextSpan(
                                                text: ' ${snapshot.data!.ratingCount} ratings',
                                                style: Theme.of(context).primaryTextTheme.displayLarge,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          !snapshot.data!.isAtivo ? MdiIcons.closeOctagon : MdiIcons.checkDecagram,
                                          size: 20,
                                          color: !snapshot.data!.isAtivo
                                              ? Colors.red
                                              : Modular.get<ThemeStore>().isDarkModeEnable
                                                  ? Colors.greenAccent
                                                  : Colors.green,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            snapshot.data!.isAtivo ? "Ativo" : "Inativo",
                                            style: Theme.of(context).primaryTextTheme.displayMedium,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Observer(builder: (_) {
                                if (_controller.svgCodigoBarras != null) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.string(_controller.svgCodigoBarras!),
                                      ),
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                              })
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: (MediaQuery.of(context).size.width - 231) / 2,
                        top: -35,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            height: 140,
                            width: 215,
                            child: SpinKitThreeBounce(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          errorWidget: (context, url, error) => const CircleAvatar(
                            radius: 100,
                            child: Icon(
                              MdiIcons.cameraOff,
                              size: 70,
                              color: Colors.white,
                            ),
                          ),
                          imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${snapshot.data!.imageUrl}',
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              width: 215,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                  image: imageProvider,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Observer(builder: (_) {
                        return CardCountProduto(
                          produtoId: widget.id,
                          estoqueDisponivel: _controller.produtoDetailDto!.estoque,
                          isAtivo: _controller.produtoDetailDto!.isAtivo,
                        );
                      }),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 20,
                              width: 100,
                              decoration: BoxDecoration(
                                color: !snapshot.data!.isDisponivel() ? Colors.redAccent : Colors.green,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data!.getDisponiveis(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).primaryTextTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Observer(builder: (_) {
                              return IconButton(
                                onPressed: () async {
                                  var favoritoRepository = Modular.get<IFavoritosRepository>();
                                  try {
                                    if (_controller.isFavorito) {
                                      _controller.isFavorito = !_controller.isFavorito;
                                      await favoritoRepository.removerFavorito(_controller.id!);
                                    } else {
                                      _controller.isFavorito = !_controller.isFavorito;
                                      await favoritoRepository.adicionarFavorito(_controller.id!);
                                    }
                                  } catch (e) {
                                    _controller.isFavorito = !_controller.isFavorito;
                                  }
                                },
                                icon: _controller.isFavorito ? Image.asset('assets/fav_red.png') : Image.asset('assets/fav_grey.png'),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Observer(builder: (_) {
                  return _controller.isVisibleFavoritos
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              "Favoritos",
                              style: Theme.of(context).primaryTextTheme.headlineSmall,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
                listaFavoritos()
              ],
            ),
          );
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
          firstPageProgressIndicatorWidget: SizedBox(
            height: 105,
            width: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Theme.of(context).cardTheme.color!,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 180,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 105,
                          width: 180,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(17),
                              bottomLeft: Radius.circular(17),
                              bottomRight: Radius.circular(17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          noMoreItemsBuilder: const SizedBox.shrink(),
          scrollDirection: Axis.horizontal,
          pagingController: pagingFavoritosController,
          request: (page) async {
            var produtosFavoritos = await Modular.get<ICatalogoRepository>().getProdutosFavoritos(page);
            _controller.isVisibleFavoritos = produtosFavoritos.total == 0;
            return produtosFavoritos;
          },
          itemBuilder: (context, item, index) {
            _controller.isVisibleFavoritos = true;

            return SizedBox(
              height: 200,
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
                          child: SpinKitThreeBounce(
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
            );
          },
          cast: CatalogoDto.fromJson,
          emptyBuilder: (context) {
            _controller.isVisibleFavoritos = false;
            return const SizedBox.shrink();
          },
          errorBuilder: (context) {
            return _errorList(() {
              pagingFavoritosController.refresh();
            });
          },
        ),
      ),
    );
  }

  Widget _errorList(Function()? refresh) {
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _controller.id = widget.id;

    super.initState();
  }
}
