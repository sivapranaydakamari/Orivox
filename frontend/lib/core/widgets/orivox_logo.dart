import 'package:flutter/material.dart';

/// Centralized brand logo widget for Orivox.
/// Displays the official product logo from assets/images/orivox_logo.png with
/// proper aspect ratio, responsive sizing, and theme-adaptive contrast.
class OrivoxLogo extends StatelessWidget {
  final double height;
  final double? width;
  final bool isHero;
  final bool forceBadge;

  const OrivoxLogo({
    super.key,
    this.height = 40,
    this.width,
    this.isHero = false,
    this.forceBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // The official logo is rendered on a white canvas.
    // In dark mode or when forceBadge is true, wrap in a sleek, rounded white badge
    // so the dark wordmark and subtle details retain optimal contrast and crispness.
    final imageWidget = Image.asset(
      'assets/images/orivox_logo.png',
      height: height,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );

    if (isDark || forceBadge) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isHero ? 16 : 8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: isHero ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(isHero ? 12 : 4),
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
