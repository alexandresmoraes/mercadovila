import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/tab/account_page.dart';
import 'package:vilasesmo/app/modules/tab/home_page.dart';
import 'package:vilasesmo/app/modules/tab/scanner_page.dart';
import 'package:vilasesmo/app/modules/tab/search_page.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

class TabPage extends StatefulWidget {
  final String title;
  const TabPage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final List<IconData> _iconDataList = [
    MdiIcons.homeOutline,
    MdiIcons.magnify,
    MdiIcons.barcodeScan,
    MdiIcons.accountOutline,
  ];
  var _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: _iconDataList.length,
          tabBuilder: (int index, bool isActive) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _iconDataList[index],
                    color: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!.color,
                    size: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!.size,
                  ),
                  onPressed: () async {
                    if ((!Platform.isAndroid && !Platform.isIOS) && index == 2) {
                      GlobalSnackbar.error('Recurso não suportado nessa plataforma');
                    } else {
                      setState(() => _bottomNavIndex = index);
                    }
                  },
                ),
                const SizedBox(height: 5),
                isActive
                    ? Container(
                        height: 2,
                        width: 15,
                        color: Theme.of(context).primaryColorLight,
                      )
                    : const SizedBox()
              ],
            );
          },
          splashRadius: 0,
          elevation: 0,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          activeIndex: _bottomNavIndex,
          notchSmoothness: NotchSmoothness.softEdge,
          gapLocation: GapLocation.center,
          onTap: (index) {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: const Color(0xFFFA692C),
          onPressed: () {
            Modular.to.pushNamed('/carrinho/');
          },
          child: Icon(
            MdiIcons.shopping,
            color: Colors.white,
            size: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!.size,
          ),
        ),
        body: _screens().elementAt(_bottomNavIndex),
      )),
    );
  }

  List<Widget> _screens() => [
        const HomePage(),
        const SearchPage(),
        const ScannerPage(),
        const AccountPage(),
      ];
}
