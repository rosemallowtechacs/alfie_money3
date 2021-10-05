import 'dart:ui';

import 'package:flutter/material.dart';
class Colorslist {
 static const Color background = Color(0XFFFFFFFF);

 static const Color titleTextColor = const Color(0xff1d2635);
 static const Color subTitleTextColor = const Color(0xff797878);

 static const Color lightBlue1 = Color(0xff375efd);
 static const Color lightBlue2 = Color(0xff3554d3);
 static const Color navyBlue1 = Color(0xff15294a);
 static const Color lightNavyBlue = Color(0xff6d7f99);
 static const Color navyBlue2 = Color(0xff2c405b);

 static const Color yellow = Color(0xfffbbd5c);
 static const Color yellow2 = Color(0xffe7ad03);

 static const Color lightGrey = Color(0xfff1f1f3);
 static const Color grey = Color(0xffb9b9b9);
 static const Color darkgrey = Color(0xff625f6a);

 static const Color black = Color(0xff040405);
 static const Color lightblack = Color(0xff3E404D);
}
const Color lightNavyBlue = Color(0xff6d7f99);
const Color lightGrey = Color(0xfff1f1f3);
 const Color Rmblue=Color(0xff268ac7);
 const Color Rmyellow=Color(0xffffd11a);
const Color Rmpick=Color(0xffff99ff);
 const Color Rmlightblue=Color(0xff0066ff);
const Color lightBlue2 = Color(0xff3554d3);
 const Color navyBlue2 = Color(0xff2c405b);

MaterialColor createMaterialColor(Color color) {
 List strengths = <double>[.05];
 final swatch = <int, Color>{};
 final int r = color.red, g = color.green, b = color.blue;

 for (int i = 1; i < 10; i++) {
  strengths.add(0.1 * i);
 }
 strengths.forEach((strength) {
  final double ds = 0.5 - strength;
  swatch[(strength * 1000).round()] = Color.fromRGBO(
   r + ((ds < 0 ? r : (255 - r)) * ds).round(),
   g + ((ds < 0 ? g : (255 - g)) * ds).round(),
   b + ((ds < 0 ? b : (255 - b)) * ds).round(),
   1,
  );
 });
 return MaterialColor(color.value, swatch);
}