import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light color constants
const lightPrimaryColor = Color(0xFF0E2954);

// Dark color constants
const darkPrimaryColor = Color(0xff1A237E); // dominant color in your app.
const darkBackgroundColor = Color(0xff121212); // used as the background for the app.
const darkAccentColor = Color(0xff448AFF); // used for highlighting buttons or interactive elements.
const darkTextColor = Color(0xffFFFFFF);  // used for text against dark backgrounds.
const darkSecondaryTextColor = Color(0xffCCCCCC); // can be used for less prominent text or as a subtle accent
const darkButtonBackgroundColor = Color(0xff1F6E8C); // slightly darker shade of the accent color for buttons.
const darkButtonTextColor = Color(0xffFFFFFF); // color will be used for text on buttons.
const darkErrorColor = Color(0xffFF5722); //  used to indicate errors or warnings


// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: lightPrimaryColor,
);

// Dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: darkPrimaryColor,
  scaffoldBackgroundColor: darkBackgroundColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        darkAccentColor,
      ),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.josefinSans(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: darkTextColor,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: darkTextColor,

    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: darkTextColor,

    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: darkPrimaryColor,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: darkPrimaryColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: darkTextColor),
    fillColor: darkBackgroundColor,
    // filled: true,
    border: OutlineInputBorder (
      borderRadius: BorderRadius.circular(200.0),
      borderSide: const BorderSide(color: darkPrimaryColor),
    )
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
  ),
  tabBarTheme: const TabBarTheme(
    indicatorColor: darkErrorColor,
    labelColor: darkAccentColor,
    labelStyle: TextStyle(
      color: darkAccentColor,
      fontSize: 15,
    ),
    unselectedLabelColor: darkTextColor,
    unselectedLabelStyle: TextStyle(
      color: darkSecondaryTextColor,
      fontSize: 15,
    ),

  ),
);
