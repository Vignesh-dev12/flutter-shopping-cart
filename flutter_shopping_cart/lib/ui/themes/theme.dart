import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/ui/themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        appBarTheme: AppBarTheme(
          elevation: 5,
          color: Colors.white,
          brightness: Brightness.dark,
          textTheme: GoogleFonts.mulishTextTheme(
            Theme.of(context).textTheme,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: primaryColor,
          labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      );

  static var boxTextFieldDecoration = (String label) => InputDecoration(
    contentPadding:
    EdgeInsets.only(top: 18, bottom: 18, left: 14, right: 14),
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.8), width: 0.7),
    ),
  );

}
