import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:jejom/utils/theme/app_theme.dart';

/// A reusable glassmorphic container with consistent styling
/// Implements the app's glassmorphic design language
class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blurIntensity;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double? marginBottom;
  final List<BoxShadow>? shadow;
  final AlignmentGeometry? alignment;
  final bool isClickable;
  final VoidCallback? onTap;
  
  const GlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.blurIntensity = 10.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.marginBottom,
    this.shadow,
    this.alignment,
    this.isClickable = false,
    this.onTap,
  });
  
  /// Factory constructor for a standard card style
  factory GlassContainer.card({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry padding = const EdgeInsets.all(AppTheme.paddingMedium),
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return GlassContainer(
      key: key,
      child: child,
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      backgroundColor: backgroundColor,
      shadow: AppTheme.shadowSmall,
      isClickable: onTap != null,
      onTap: onTap,
    );
  }
  
  /// Factory constructor for a button style
  factory GlassContainer.button({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: AppTheme.paddingLarge,
      vertical: AppTheme.paddingMedium,
    ),
    Color? backgroundColor,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GlassContainer(
      key: key,
      child: child,
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      backgroundColor: isActive ? AppTheme.travelPrimary.withOpacity(0.3) : Colors.white.withOpacity(0.15),
      borderColor: isActive ? AppTheme.travelPrimary.withOpacity(0.5) : Colors.white.withOpacity(0.25),
      shadow: isActive ? AppTheme.shadowMedium : AppTheme.shadowSmall,
      isClickable: true,
      onTap: onTap,
    );
  }
  
  /// Factory constructor for a modal style
  factory GlassContainer.modal({
    Key? key,
    required Widget child,
    double? width,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry padding = const EdgeInsets.all(AppTheme.paddingLarge),
  }) {
    return GlassContainer(
      key: key,
      child: child,
      width: width,
      margin: margin,
      padding: padding,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppTheme.borderRadiusLarge),
        topRight: Radius.circular(AppTheme.borderRadiusLarge),
      ),
      blurIntensity: 15.0,
      shadow: AppTheme.shadowLarge,
    );
  }

  @override
  Widget build(BuildContext context) {
    final container = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurIntensity,
          sigmaY: blurIntensity,
        ),
        child: Container(
          width: width,
          height: height,
          margin: margin,
          padding: padding ?? const EdgeInsets.all(AppTheme.paddingMedium),
          alignment: alignment,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withOpacity(0.15),
            borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.25),
              width: borderWidth,
            ),
            boxShadow: shadow,
          ),
          child: child,
        ),
      ),
    );
    
    if (isClickable && onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    
    return container;
  }
} 