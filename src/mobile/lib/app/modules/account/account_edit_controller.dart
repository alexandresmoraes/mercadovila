import 'package:mobx/mobx.dart';

part 'account_edit_controller.g.dart';

class AccountEditController = _AccountEditControllerBase with _$AccountEditController;

abstract class _AccountEditControllerBase with Store {
  @observable
  String? fotoPath;
  @action
  void setfotoPath(String? v) => fotoPath = v;
}
