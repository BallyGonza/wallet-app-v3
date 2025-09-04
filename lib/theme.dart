import 'package:flutter/material.dart';
import 'package:template_app/core/constants/colors.dart';

ThemeData appThemeLight = ThemeData(
  scaffoldBackgroundColor: LightThemeColors.backgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: LightThemeColors.accentColor,
    primary: LightThemeColors.primaryColor.withValues(),
    secondary: LightThemeColors.secondaryColor.withValues(),
  ),
  primaryColor: Colors.white,
  fontFamily: 'StyreneB',
  appBarTheme: const AppBarTheme(
    backgroundColor: LightThemeColors.primaryColor,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'StyreneB',
    ),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: LightThemeColors.primaryColor,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    indicatorColor: LightThemeColors.primaryColor,
  ),
  cardColor: LightThemeColors.secondaryColor,
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      backgroundColor: WidgetStateProperty.all(LightThemeColors.accentColor),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'StyreneB',
          color: Colors.black,
        ),
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      backgroundColor: WidgetStateProperty.all(LightThemeColors.accentColor),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      backgroundColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(LightThemeColors.accentColor),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: LightThemeColors.primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

ThemeData appThemeDark = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DarkThemeColors.backgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: DarkThemeColors.accentColor,
    brightness: Brightness.dark,
    primary: DarkThemeColors.primaryColor.withValues(),
    secondary: DarkThemeColors.secondaryColor.withValues(),
  ),
  primaryColor: DarkThemeColors.primaryColor.withValues(),
  fontFamily: 'StyreneB',
  appBarTheme: AppBarTheme(
    backgroundColor: DarkThemeColors.primaryColor.withValues(),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'StyreneB',
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: DarkThemeColors.primaryColor.withValues(),
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: DarkThemeColors.primaryColor.withValues(),
  ),
  cardColor: Colors.grey[900],
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      backgroundColor:
          WidgetStateProperty.all(DarkThemeColors.primaryColor.withValues()),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'StyreneB',
          color: DarkThemeColors.accentColor,
        ),
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      backgroundColor:
          WidgetStateProperty.all(DarkThemeColors.primaryColor.withValues()),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'StyreneB',
          color: DarkThemeColors.accentColor,
        ),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      backgroundColor: WidgetStateProperty.all(Colors.black87),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      side: WidgetStateProperty.all(
        const BorderSide(color: DarkThemeColors.primaryColor),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'StyreneB',
          color: DarkThemeColors.accentColor,
        ),
      ),
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: DarkThemeColors.backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
);
