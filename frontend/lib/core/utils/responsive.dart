import 'package:flutter/material.dart';

class Responsive {
  // Breakpoints
  static const double mobileMaxSize = 600;
  static const double tabletMaxSize = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMaxSize;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileMaxSize &&
      MediaQuery.sizeOf(context).width < tabletMaxSize;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMaxSize;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Responsive.tabletMaxSize) {
          return desktop;
        } else if (constraints.maxWidth >= Responsive.mobileMaxSize) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
