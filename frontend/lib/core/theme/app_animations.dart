import 'package:flutter/material.dart';

class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve emphasizeCurve = Curves.fastOutSlowIn;
  static const Curve decelerationCurve = Curves.easeOutQuart;
  static const Curve accelerationCurve = Curves.easeInQuart;
}
