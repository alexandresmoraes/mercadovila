import 'package:mobx/mobx.dart';

part 'account_edit_controller.g.dart';

class AccountEditController = _AccountEditControllerBase with _$AccountEditController;

abstract class _AccountEditControllerBase with Store {
  bool isFotoAlterada = false;

  @observable
  String? photoPath;

  @action
  void setPhotoPath(String v) {
    isFotoAlterada = true;
    photoPath = v;
  }
}
