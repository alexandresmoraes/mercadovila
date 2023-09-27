import 'package:mobx/mobx.dart';

part 'favorito_controller.g.dart';

class FavoritoController = FavoritoControllerBase with _$FavoritoController;

abstract class FavoritoControllerBase with Store {
  @observable
  bool isFavorito = false;
}
