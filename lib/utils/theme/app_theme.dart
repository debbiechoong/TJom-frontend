import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

/// AppTheme encapsulates the app's styling guidelines, including colors, typography,
/// glassmorphic elements, animations, and other styling constants.
class AppTheme {
  /// COLORS
  /// Color palette inspired by Taiwan's landscape with travel/game mode options

  // Primary colors for travel mode
  static const Color travelPrimary = Color(0xFF3B82F6); // Blue lake
  static const Color travelSecondary = Color(0xFF10B981); // Green mountains
  static const Color travelAccent = Color(0xFFF59E0B); // Golden sunset

  // Primary colors for game/mystery mode
  static const Color gamePrimary = Color(0xFF8B5CF6); // Purple mystery
  static const Color gameSecondary = Color(0xFFEC4899); // Pink intrigue
  static const Color gameAccent = Color(0xFF06B6D4); // Cyan clue

  // Neutral colors
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFD1D5DB);
  static const Color background = Color(0xFFF9FAFB);
  static const Color backgroundSecondary = Color(0xFFF3F4F6);
  static const Color surface = Color(0xFFFFFFFF);

  // Gradient backgrounds
  static const LinearGradient travelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE0E6FF), // Light blue
      Color(0xFFD5E6F3), // Soft sky blue
    ],
  );

  static const LinearGradient gameGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEDE5FF), // Light purple
      Color(0xFFF5E7F5), // Soft pink
    ],
  );

  /// TYPOGRAPHY
  /// Text styles for consistent hierarchy throughout the app

  // Font family
  static const String fontFamily = 'Akzidenz-Grotesk';

  // Headings
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: textDark,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textDark,
    height: 1.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textDark,
    height: 1.4,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textDark,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textDark,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textMedium,
    height: 1.6,
  );

  // Button and caption text
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textDark,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textDark,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textDark,
    height: 1.5,
  );

  /// GLASSMORPHIC ELEMENTS
  /// Styling for glass-like UI elements

  // Standard border radius for glassmorphic elements
  static const double borderRadius = 16.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusLarge = 24.0;

  // Common padding values
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Glass card decoration
  static BoxDecoration glassCard({Color? color, double blur = 10.0}) {
    return BoxDecoration(
      color: (color ?? Colors.white).withOpacity(0.2),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withOpacity(0.3),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Glass button decoration
  static BoxDecoration glassButton({bool isActive = false}) {
    return BoxDecoration(
      color: (isActive ? travelPrimary : Colors.white).withOpacity(isActive ? 0.3 : 0.15),
      borderRadius: BorderRadius.circular(borderRadiusSmall),
      border: Border.all(
        color: Colors.white.withOpacity(0.25),
        width: 1.5,
      ),
    );
  }

  // Glass toggle decoration
  static BoxDecoration glassToggle({bool isSelected = false}) {
    return BoxDecoration(
      color: (isSelected ? travelPrimary : Colors.white).withOpacity(isSelected ? 0.3 : 0.15),
      borderRadius: BorderRadius.circular(borderRadiusSmall),
      border: Border.all(
        color: isSelected ? travelPrimary.withOpacity(0.5) : Colors.white.withOpacity(0.25),
        width: 1.5,
      ),
    );
  }

  // Glass text field decoration
  static BoxDecoration glassTextField() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(borderRadiusSmall),
      border: Border.all(
        color: Colors.white.withOpacity(0.25),
        width: 1.5,
      ),
    );
  }

  // Glass modal decoration
  static BoxDecoration glassModal() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadiusLarge),
        topRight: Radius.circular(borderRadiusLarge),
      ),
      border: Border.all(
        color: Colors.white.withOpacity(0.3),
        width: 1.5,
      ),
    );
  }

  /// ANIMATIONS
  /// Durations and curves for app animations

  // Animation durations
  static const Duration animDurationFast = Duration(milliseconds: 200);
  static const Duration animDurationMedium = Duration(milliseconds: 300);
  static const Duration animDurationSlow = Duration(milliseconds: 500);

  // Animation curves
  static const Curve animCurveStandard = Curves.easeInOut;
  static const Curve animCurveEnter = Curves.easeOut;
  static const Curve animCurveExit = Curves.easeIn;
  static const Curve animCurveElastic = Curves.elasticOut;

  /// SHADOWS
  /// Common shadow styles

  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  /// SYSTEM UI
  /// Configure system UI to match app theme

  static void configureSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  /// THEME DATA
  /// Material theme configuration

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: fontFamily,
      primaryColor: travelPrimary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: travelPrimary,
        secondary: travelSecondary,
        surface: surface,
        background: background,
        error: Colors.red.shade700,
      ),
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: displaySmall,
        iconTheme: IconThemeData(color: textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: travelPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingMedium,
          ),
          textStyle: labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: travelPrimary,
          side: BorderSide(color: travelPrimary),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingMedium,
          ),
          textStyle: labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: travelPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingMedium,
            vertical: paddingSmall,
          ),
          textStyle: labelMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        contentPadding: const EdgeInsets.all(paddingMedium),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: BorderSide(
            color: travelPrimary.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: BorderSide(
            color: Colors.red.shade700,
            width: 1.5,
          ),
        ),
        hintStyle: bodyMedium.copyWith(color: textMedium),
      ),
    );
  }

  /// Create a glassmorphic effect widget with specified parameters
  static Widget createGlassEffect({
    required Widget child,
    double blurIntensity = 10.0,
    Color backgroundColor = Colors.transparent,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry padding = const EdgeInsets.all(paddingMedium),
  }) {
    final BorderRadius effectBorderRadius = borderRadius ?? BorderRadius.circular(AppTheme.borderRadius);
    
    return ClipRRect(
      borderRadius: effectBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurIntensity,
          sigmaY: blurIntensity,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.2),
            borderRadius: effectBorderRadius,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
} 