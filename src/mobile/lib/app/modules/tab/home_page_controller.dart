import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/catalogo/catalogo_dto.dart';

part 'home_page_controller.g.dart';

class HomePageController = HomePageControllerBase with _$HomePageController;

abstract class HomePageControllerBase with Store, Disposable {
  PagingController<int, CatalogoDto> pagingNovosController = PagingController(firstPageKey: 1);
  PagingController<int, CatalogoDto> pagingFavoritosController = PagingController(firstPageKey: 1);
  PagingController<int, CatalogoDto> pagingMaisVendidosController = PagingController(firstPageKey: 1);
  PagingController<int, CatalogoDto> pagingUltimosVendidosController = PagingController(firstPageKey: 1);

  @observable
  bool isVisibleNovos = false;

  @observable
  bool isVisibleMaisVendidos = false;

  @observable
  bool isVisibleUltimosVendidos = false;

  @observable
  bool isVisibleFavoritos = false;

  @observable
  bool isFavoritosEmpty = false;

  @observable
  int currentIndexCarouselSlider = 0;

  @override
  void dispose() {
    pagingNovosController.dispose();
    pagingFavoritosController.dispose();
    pagingMaisVendidosController.dispose();
    pagingUltimosVendidosController.dispose();
  }
}
