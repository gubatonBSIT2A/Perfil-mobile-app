import 'package:flutter/material.dart';

const primaryColor = Color(0xffff0a54);
const secondaryColor = Color(0xffffc4d6);
const tertiaryColor = Color(0xffF5F6FB);
const whiteColor = Colors.white;
const newBlack = Color(0xff212529);

ThemeData lightTheme = ThemeData(

  fontFamily: 'Inter',
  inputDecorationTheme: const InputDecorationTheme(

    // suffixIconColor: primaryColor,
    focusColor: primaryColor,
    floatingLabelStyle: TextStyle(color: primaryColor),
    border: OutlineInputBorder(),
    isDense: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: primaryColor,
        width: 2.0,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(
      primaryColor,
    ),
  )),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: newBlack
    ),
      actionsIconTheme: IconThemeData(
        color: primaryColor,
        size: 30,
      ),
      titleTextStyle: TextStyle(),
      backgroundColor: whiteColor),
  scaffoldBackgroundColor: tertiaryColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: whiteColor,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: primaryColor,
    selectedIconTheme: IconThemeData(
      size: 30,
      color: primaryColor,
    ),
    unselectedIconTheme: IconThemeData(
      size: 30,
      color: secondaryColor,
    ),
    unselectedItemColor: secondaryColor,
  ),
);
