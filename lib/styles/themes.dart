import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color defColor = Colors.lightBlueAccent;

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  appBarTheme:   AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 20,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20),
      iconTheme: IconThemeData(color: Colors.black)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed, elevation: 20),
  textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.black)),
  primarySwatch:  Colors.lightBlue,
);

ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.lightBlue,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        backgroundColor: Color(0xff333739),
        unselectedItemColor: Colors.grey),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff333739),
        elevation: 0,
        titleSpacing: 20,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xff333739),
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        iconTheme: IconThemeData(color: Colors.white)),
    scaffoldBackgroundColor: const Color(0xff333739),
    textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white)));