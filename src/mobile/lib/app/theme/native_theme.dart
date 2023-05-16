import 'package:flutter/material.dart';

ThemeData nativeTheme({required bool isDarkModeEnable}) {
  if (isDarkModeEnable) {
    Map<int, Color> color = {
      50: const Color.fromRGBO(244, 105, 74, .1),
      100: const Color.fromRGBO(244, 105, 74, .2),
      200: const Color.fromRGBO(244, 105, 74, .3),
      300: const Color.fromRGBO(244, 105, 74, .4),
      400: const Color.fromRGBO(244, 105, 74, .5),
      500: const Color.fromRGBO(244, 105, 74, .6),
      600: const Color.fromRGBO(244, 105, 74, .7),
      700: const Color.fromRGBO(244, 105, 74, .8),
      800: const Color.fromRGBO(244, 105, 74, .9),
      900: const Color.fromRGBO(244, 105, 74, 1),
    };
    return ThemeData(
      canvasColor: Colors.grey,
      primaryColor: const Color(0xFFF4694A),
      primaryColorLight: const Color(0xFFF6A643),
      primaryColorDark: const Color(0xFFF4694A),
      primarySwatch: MaterialColor(0xFFF4694A, color),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      iconTheme: const IconThemeData(color: Color(0xFF9EA5A8)),
      primaryTextTheme: TextTheme(
        displayLarge:
            const TextStyle(fontSize: 13, color: Color(0xFFFCB140), letterSpacing: 0.5, fontWeight: FontWeight.w500, fontFamily: 'PoppinsMedium'),
        displayMedium: const TextStyle(fontSize: 12, color: Color(0xFF9EA5A8), fontWeight: FontWeight.w400, fontFamily: 'PoppinsRegular'),
        displaySmall: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        headlineMedium: const TextStyle(color: Colors.white70, fontSize: 17),
        headlineSmall:
            const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.3, fontFamily: 'PoppinsMedium'),
        titleLarge: const TextStyle(fontSize: 18, color: Colors.white),
        labelLarge: const TextStyle(fontSize: 10, color: Color(0xFF9EA5A8), fontWeight: FontWeight.w400, fontFamily: 'PoppinsRegular'),
        titleMedium: const TextStyle(fontSize: 14, color: Color(0xFF332E38), fontWeight: FontWeight.w500, fontFamily: 'PoppinsMedium'),
        titleSmall: const TextStyle(fontSize: 12, color: Color(0xFF332E38), fontWeight: FontWeight.w300, fontFamily: 'PoppinsLight'),
        bodyLarge: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 0.3, fontFamily: 'PoppinsMedium'),
        labelSmall: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w400, fontFamily: 'PoppinsRegular'),
        bodySmall: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      scaffoldBackgroundColor: const Color(0xFF242639),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        labelStyle: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.only(top: 10, bottom: 10)),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
      )),
      fontFamily: 'PoppinsMedium',
      dividerColor: Colors.transparent,
      dividerTheme: DividerThemeData(color: const Color(0xFFEDF2F6).withOpacity(0.5), thickness: 1.5),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(const Color(0xFFF4694A)),
      ),
      cardTheme: CardTheme(
        elevation: 0.5,
        margin: const EdgeInsets.all(0),
        color: const Color(0xFF2D2F41),
        shadowColor: const Color(0xFF2D2F41),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400, fontFamily: 'PoppinsRegular'),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide.none),
        filled: true,
        fillColor: Color(0xFF4B4F68),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF404058),
        selectedIconTheme: IconThemeData(color: Color(0xFFF6A643), size: 26),
        unselectedIconTheme: IconThemeData(color: Colors.white, size: 24),
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        color: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.white),
        fillColor: MaterialStateProperty.all(
          const Color(0xFFF4694A),
        ),
      ),
    );
  } else {
    Map<int, Color> color = {
      50: const Color.fromRGBO(244, 105, 74, .1),
      100: const Color.fromRGBO(244, 105, 74, .2),
      200: const Color.fromRGBO(244, 105, 74, .3),
      300: const Color.fromRGBO(244, 105, 74, .4),
      400: const Color.fromRGBO(244, 105, 74, .5),
      500: const Color.fromRGBO(244, 105, 74, .6),
      600: const Color.fromRGBO(244, 105, 74, .7),
      700: const Color.fromRGBO(244, 105, 74, .8),
      800: const Color.fromRGBO(244, 105, 74, .9),
      900: const Color.fromRGBO(244, 105, 74, 1),
    };
    return ThemeData(
      canvasColor: Colors.grey,
      primaryColor: const Color(0xFFF4694A),
      primaryColorLight: const Color(0xFFF6A643),
      primaryColorDark: const Color(0xFFF4694A),
      primarySwatch: MaterialColor(0xFFF4694A, color),
      primaryIconTheme: const IconThemeData(color: Color(0xFF332E38)),
      iconTheme: const IconThemeData(color: Color(0xFF738899)),
      primaryTextTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 13, color: Color(0xFFEF5656), letterSpacing: 0.5, fontWeight: FontWeight.w500, fontFamily: 'PoppinsMedium'),
        displayMedium: TextStyle(fontSize: 12, color: Color(0xFF9EA5A8), fontWeight: FontWeight.w400, fontFamily: 'PoppinsRegular'),
        displaySmall: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        headlineMedium: TextStyle(color: Colors.white70, fontSize: 17),
        headlineSmall:
            TextStyle(color: Color(0xFF332E38), fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.3, fontFamily: 'PoppinsMedium'),
        titleLarge: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(fontSize: 10, color: Color(0xFF41505B), fontWeight: FontWeight.w400, fontFamily: 'PoppinsRegular'),
        titleMedium: TextStyle(fontSize: 14, color: Color(0xFF332E38), fontWeight: FontWeight.w500, fontFamily: 'PoppinsMedium'),
        titleSmall: TextStyle(fontSize: 12, color: Color(0xFF332E38), fontWeight: FontWeight.w300, fontFamily: 'PoppinsLight'),
        bodyLarge: TextStyle(fontSize: 14, color: Color(0xFF332E38), fontWeight: FontWeight.w500, letterSpacing: 0.3, fontFamily: 'PoppinsMedium'),
        labelSmall: TextStyle(fontSize: 14, color: Color(0xFF332E38), fontWeight: FontWeight.w400, fontFamily: 'PoppinsRegular'),
        bodySmall: TextStyle(color: Colors.white, fontSize: 12),
      ),
      scaffoldBackgroundColor: Colors.white,
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        labelStyle: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.only(top: 10, bottom: 10)),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
      )),
      fontFamily: 'PoppinsMedium',
      dividerColor: Colors.transparent,
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(const Color(0xFFF4694A)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color(0xFF5c7de0)),
      cardTheme: CardTheme(
        elevation: 0.5,
        margin: const EdgeInsets.all(0),
        color: const Color(0xFFedf2f6),
        shadowColor: const Color(0xFFedf2f6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEDF2F6),
        thickness: 1.5,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 14, color: Color(0xFF6E7A82), fontWeight: FontWeight.w400, fontFamily: 'PoppinsRegular'),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide.none),
        filled: true,
        fillColor: Color(0xFFEDF2F6),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFAF9F9),
        selectedIconTheme: IconThemeData(color: Color(0xFFF6A643), size: 26),
        unselectedIconTheme: IconThemeData(color: Color(0xFF4A4352), size: 24),
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        color: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: 'PoppinsRegular'),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.white),
        fillColor: MaterialStateProperty.all(
          const Color(0xFFF4694A),
        ),
      ),
    );
  }
}
