import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

abstract class AppConst {
  static Gradient primaryGradient = LinearGradient(
    colors: [HexColor('#39b5fb'), HexColor('#000000')],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static Gradient splashGradient = LinearGradient(
    colors: [HexColor('#39b5fb'), HexColor('#000000'), HexColor('#39b5fb')],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );
  static Color primary = HexColor('#39b5fb');
  static Color secondary = HexColor('#000000');
  static Color red = Colors.red;
  static Color green = Colors.green;
  static Color brightWhite = HexColor('#39b5fb');
  static Color white = HexColor('#ffffff');
  static Color black = HexColor('#000000');
  static Color grey = Colors.grey;
  static Color grey400 = Colors.grey.shade400;
  static Color grey300 = Colors.grey.shade200;
  static Color gold = HexColor('#ecb337');
  static Color brown = HexColor('#452612');
  static Color whiteOpacity = Colors.white.withOpacity(0.8);
  static Color blackOpacity = Color.fromARGB(154, 0, 0, 0);
  static Color transparent = Colors.transparent;
}
