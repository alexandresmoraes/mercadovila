import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:mercadovila/app/app_widget.dart';

class GlobalSnackbar {
  static void warning(String content) {
    AnimatedSnackBar.material(
      content,
      type: AnimatedSnackBarType.warning,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: const Duration(seconds: 4),
    ).show(AppWidget.navigatorKey.currentState!.context);
  }

  static void error(String content) {
    AnimatedSnackBar.material(
      content,
      type: AnimatedSnackBarType.error,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: const Duration(seconds: 4),
    ).show(AppWidget.navigatorKey.currentState!.context);
  }

  static void message(String content) {
    AnimatedSnackBar.material(
      content,
      type: AnimatedSnackBarType.info,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: const Duration(seconds: 4),
    ).show(AppWidget.navigatorKey.currentState!.context);
  }

  static void success(String content) {
    AnimatedSnackBar.material(
      content,
      type: AnimatedSnackBarType.success,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: const Duration(seconds: 4),
    ).show(AppWidget.navigatorKey.currentState!.context);
  }
}
