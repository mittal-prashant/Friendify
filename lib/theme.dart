import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: mainPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: mainContentColorLightTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: mainContentColorLightTheme),
    colorScheme: ColorScheme.light(
      primary: mainPrimaryColor,
      secondary: mainSecondaryColor,
      error: mainErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: mainContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: mainContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: mainPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: mainPrimaryColor,
    scaffoldBackgroundColor: mainContentColorLightTheme,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: mainContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: mainContentColorDarkTheme),
    colorScheme: ColorScheme.dark().copyWith(
      primary: mainPrimaryColor,
      secondary: mainSecondaryColor,
      error: mainErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: mainContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: mainContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: mainPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

final appBarTheme =
    AppBarTheme(centerTitle: false, elevation: 0, color: mainPrimaryColor);
