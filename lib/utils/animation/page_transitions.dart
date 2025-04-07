import 'package:flutter/material.dart';
import 'package:jejom/utils/theme/app_theme.dart';

/// AppPageTransitions provides standardized transition animations for app navigation
/// Ensures consistent and polished animations throughout the app
class AppPageTransitions {
  /// Standard transition featuring a smooth fade and slide effect
  /// Use for most standard navigation between main screens
  static PageRouteBuilder fadeThrough({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: AppTheme.animCurveStandard,
        );
        
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(fadeAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// More dramatic transition for game-related screens
  /// Incorporates a scale effect for emphasis
  static PageRouteBuilder gameTransition({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: AppTheme.animCurveStandard,
        );
        
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Horizontal slide transition for onboarding flows
  /// Creates a natural progression feeling for multi-step processes
  static PageRouteBuilder slideHorizontal({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 250),
    bool isForward = true,
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: AppTheme.animCurveEnter,
        );
        
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(isForward ? 1.0 : -1.0, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  /// Modal popup transition that animates from the bottom
  /// Ideal for bottom sheets and dialogs
  static PageRouteBuilder modalUpward({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuint,
        );
        
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  /// Create a custom page route with a specific transition
  static Route<T> customRoute<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
    required AnimatedWidget Function(Animation<double>, Widget) transition,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return transition(animation, child);
      },
    );
  }
} 