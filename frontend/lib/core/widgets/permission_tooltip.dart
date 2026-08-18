import 'package:flutter/material.dart';

class PermissionTooltip extends StatelessWidget {
  final bool hasPermission;
  final String requiredRole;
  final Widget child;

  const PermissionTooltip({
    super.key,
    required this.hasPermission,
    required this.requiredRole,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (hasPermission) return child;

    return Tooltip(
      message: 'Requires $requiredRole permission',
      child: Opacity(
        opacity: 0.5,
        child: IgnorePointer(
          ignoring: true,
          child: child,
        ),
      ),
    );
  }
}
