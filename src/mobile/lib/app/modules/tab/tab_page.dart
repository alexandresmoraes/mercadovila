import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/home/home_page.dart';

import '../account/account_page.dart';

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
  // late final HomeStore store;
  var _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // store = Modular.get<HomeStore>();
  }

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
                Icon(
                  _iconDataList[index],
                  color: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!.color,
                  size: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!.size,
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
          onTap: (index) => setState(() => _bottomNavIndex = index),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: const Color(0xFFFA692C),
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     // builder: (context) => CheckoutScreen(a: widget.analytics, o: widget.observer),
              //   ),
              // );
            },
            child: Icon(
              MdiIcons.shopping,
              color: Colors.white,
              size: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!.size,
            )),
        body: _screens().elementAt(_bottomNavIndex),
      )),
    );
  }

  List<Widget> _screens() => [
        const HomePage(),
        const AccountPage(),
        const AccountPage(),
        const AccountPage(),
      ];
}
