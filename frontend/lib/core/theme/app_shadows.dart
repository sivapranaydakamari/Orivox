import 'package:flutter/material.dart';

class AppShadows {
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 3.0;
  static const double elevation3 = 6.0;
  static const double elevation4 = 8.0;
  static const double elevation5 = 12.0;

  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x0C000000), // 5% black
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x26000000), // 15% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}
