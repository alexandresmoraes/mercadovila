import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _bottomNavIndex = 0;
  late final HomeStore store;
  final List<IconData> _iconDataList = [MdiIcons.homeOutline, MdiIcons.magnify, MdiIcons.brightnessPercent, MdiIcons.accountOutline];

  @override
  void initState() {
    super.initState();
    store = Modular.get<HomeStore>();
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
          itemCount: _iconDataList.length, //global.isDarkModeEnable ? darkimageList.length : lightImageList.length,
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
                // global.isDarkModeEnable ? Image.asset(darkimageList[index]) : Image.asset(lightImageList[index]),
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
        // body: _screens().elementAt(_bottomNavIndex),
      )),
    );
  }
}
