import 'package:mobx/mobx.dart';

part 'account_edit_controller.g.dart';

class AccountEditController = _AccountEditControllerBase with _$AccountEditController;

abstract class _AccountEditControllerBase with Store {
  @observable
  String? fotoBase64;
  @action
  void setFotoBase64(String? v) => fotoBase64 = v;

  @observable
  String? fotoPath;
  @action
  void setfotoPath(String? v) => fotoPath = v;
}
