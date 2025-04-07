import 'package:flutter/material.dart';
import 'package:jejom/utils/theme/app_theme.dart';

/// A consistent back button that can be used across all screens
/// Provides standardized styling and behavior for app navigation
class AppBackButton extends StatelessWidget {
  /// Custom onTap action. If null, defaults to Navigator.pop
  final VoidCallback? onTap;
  
  /// Whether to show a background behind the icon
  final bool hasBackground;
  
  /// Optional tooltip text for the back button
  final String? tooltip;
  
  /// Icon to display (defaults to back arrow)
  final IconData icon;
  
  /// Color of the icon (defaults to textDark)
  final Color? iconColor;
  
  /// Size of the icon (defaults to 24)
  final double iconSize;

  const AppBackButton({
    super.key,
    this.onTap,
    this.hasBackground = true,
    this.tooltip,
    this.icon = Icons.arrow_back_ios_rounded,
    this.iconColor,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? 'Back',
      child: GestureDetector(
        onTap: onTap ?? () => Navigator.of(context).pop(),
        child: hasBackground
            ? Container(
                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppTheme.textDark,
                  size: iconSize,
                ),
              )
            : Icon(
                icon,
                color: iconColor ?? AppTheme.textDark,
                size: iconSize,
              ),
      ),
    );
  }
} 