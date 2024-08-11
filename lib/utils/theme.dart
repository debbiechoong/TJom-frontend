import "package:flutter/material.dart";

// Extension on ColorScheme to add custom properties
extension CustomColorScheme on ColorScheme {
  Color get surfaceContainerLowest => const Color(0xFFFFFFFF);
  Color get surfaceContainerLow => const Color(0xFFFAFAFA);
  Color get surfaceContainer => const Color(0xFFF5F5F5);
  Color get surfaceContainerHigh => const Color(0xFFE0E0E0);
  Color get surfaceContainerHighest => const Color(0xFFBDBDBD);
}

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff656100),
      surfaceTint: Color(0xff656100),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfffdf425),
      onPrimaryContainer: Color(0xff545100),
      secondary: Color(0xff646111),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffeee88b),
      onSecondaryContainer: Color(0xff4e4b00),
      tertiary: Color(0xff4b6700),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd0ff6e),
      onTertiaryContainer: Color(0xff3e5700),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffefae5),
      onSurface: Color(0xff1d1c10),
      onSurfaceVariant: Color(0xff494832),
      outline: Color(0xff7a785f),
      outlineVariant: Color(0xffcbc7ab),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323124),
      inversePrimary: Color(0xffd3cb00),
      // primaryFixed: Color(0xfff1e80e),
      // onPrimaryFixed: Color(0xff1e1c00),
      // primaryFixedDim: Color(0xffd3cb00),
      // onPrimaryFixedVariant: Color(0xff4c4900),
      // secondaryFixed: Color(0xffece68a),
      // onSecondaryFixed: Color(0xff1e1c00),
      // secondaryFixedDim: Color(0xffcfca71),
      // onSecondaryFixedVariant: Color(0xff4c4900),
      // tertiaryFixed: Color(0xffc0f452),
      // onTertiaryFixed: Color(0xff141f00),
      // tertiaryFixedDim: Color(0xffa5d736),
      // onTertiaryFixedVariant: Color(0xff374e00),
      // surfaceDim: Color(0xffdedac7),
      // surfaceBright: Color(0xfffefae5),
      // surfaceContainerLowest: Color(0xffffffff),
      // surfaceContainerLow: Color(0xfff8f4e0),
      // surfaceContainer: Color(0xfff2eeda),
      // surfaceContainerHigh: Color(0xffede8d5),
      // surfaceContainerHighest: Color(0xffe7e3cf),
      background: Color(0xfff2eeda),
      onBackground: Color(0xff1d1c10),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  // static ColorScheme lightMediumContrastScheme() {
  //   return const ColorScheme(
  //     brightness: Brightness.light,
  //     primary: Color(0xff484500),
  //     surfaceTint: Color(0xff656100),
  //     onPrimary: Color(0xffffffff),
  //     primaryContainer: Color(0xff7c7700),
  //     onPrimaryContainer: Color(0xffffffff),
  //     secondary: Color(0xff484500),
  //     onSecondary: Color(0xffffffff),
  //     secondaryContainer: Color(0xff7b7727),
  //     onSecondaryContainer: Color(0xffffffff),
  //     tertiary: Color(0xff344900),
  //     onTertiary: Color(0xffffffff),
  //     tertiaryContainer: Color(0xff5d7f00),
  //     onTertiaryContainer: Color(0xffffffff),
  //     error: Color(0xff8c0009),
  //     onError: Color(0xffffffff),
  //     errorContainer: Color(0xffda342e),
  //     onErrorContainer: Color(0xffffffff),
  //     surface: Color(0xfffefae5),
  //     onSurface: Color(0xff1d1c10),
  //     onSurfaceVariant: Color(0xff45442e),
  //     outline: Color(0xff626049),
  //     outlineVariant: Color(0xff7e7c63),
  //     shadow: Color(0xff000000),
  //     scrim: Color(0xff000000),
  //     inverseSurface: Color(0xff323124),
  //     inversePrimary: Color(0xffd3cb00),
  //     // primaryFixed: Color(0xff7c7700),
  //     // onPrimaryFixed: Color(0xffffffff),
  //     // primaryFixedDim: Color(0xff625e00),
  //     // onPrimaryFixedVariant: Color(0xffffffff),
  //     // secondaryFixed: Color(0xff7b7727),
  //     // onSecondaryFixed: Color(0xffffffff),
  //     // secondaryFixedDim: Color(0xff625e0e),
  //     // onSecondaryFixedVariant: Color(0xffffffff),
  //     // tertiaryFixed: Color(0xff5d7f00),
  //     // onTertiaryFixed: Color(0xffffffff),
  //     // tertiaryFixedDim: Color(0xff496500),
  //     // onTertiaryFixedVariant: Color(0xffffffff),
  //     // surfaceDim: Color(0xffdedac7),
  //     // surfaceBright: Color(0xfffefae5),
  //     // surfaceContainerLowest: Color(0xffffffff),
  //     // surfaceContainerLow: Color(0xfff8f4e0),
  //     // surfaceContainer: Color(0xfff2eeda),
  //     // surfaceContainerHigh: Color(0xffede8d5),
  //     // surfaceContainerHighest: Color(0xffe7e3cf),
  //     background:  Color(0xfff2eeda),
  //     onBackground:  Color(0xff1d1c10),
  //   );
  // }

  // ThemeData lightMediumContrast() {
  //   return theme(lightMediumContrastScheme());
  // }

  // static ColorScheme lightHighContrastScheme() {
  //   return const ColorScheme(
  //     brightness: Brightness.light,
  //     primary: Color(0xff252300),
  //     surfaceTint: Color(0xff656100),
  //     onPrimary: Color(0xffffffff),
  //     primaryContainer: Color(0xff484500),
  //     onPrimaryContainer: Color(0xffffffff),
  //     secondary: Color(0xff252300),
  //     onSecondary: Color(0xffffffff),
  //     secondaryContainer: Color(0xff484500),
  //     onSecondaryContainer: Color(0xffffffff),
  //     tertiary: Color(0xff192600),
  //     onTertiary: Color(0xffffffff),
  //     tertiaryContainer: Color(0xff344900),
  //     onTertiaryContainer: Color(0xffffffff),
  //     error: Color(0xff4e0002),
  //     onError: Color(0xffffffff),
  //     errorContainer: Color(0xff8c0009),
  //     onErrorContainer: Color(0xffffffff),
  //     surface: Color(0xfffefae5),
  //     onSurface: Color(0xff000000),
  //     onSurfaceVariant: Color(0xff262512),
  //     outline: Color(0xff45442e),
  //     outlineVariant: Color(0xff45442e),
  //     shadow: Color(0xff000000),
  //     scrim: Color(0xff000000),
  //     inverseSurface: Color(0xff323124),
  //     inversePrimary: Color(0xfffbf221),
  //     primaryFixed: Color(0xff484500),
  //     onPrimaryFixed: Color(0xffffffff),
  //     primaryFixedDim: Color(0xff302e00),
  //     onPrimaryFixedVariant: Color(0xffffffff),
  //     secondaryFixed: Color(0xff484500),
  //     onSecondaryFixed: Color(0xffffffff),
  //     secondaryFixedDim: Color(0xff302e00),
  //     onSecondaryFixedVariant: Color(0xffffffff),
  //     tertiaryFixed: Color(0xff344900),
  //     onTertiaryFixed: Color(0xffffffff),
  //     tertiaryFixedDim: Color(0xff223200),
  //     onTertiaryFixedVariant: Color(0xffffffff),
  //     surfaceDim: Color(0xffdedac7),
  //     surfaceBright: Color(0xfffefae5),
  //     surfaceContainerLowest: Color(0xffffffff),
  //     surfaceContainerLow: Color(0xfff8f4e0),
  //     surfaceContainer: Color(0xfff2eeda),
  //     surfaceContainerHigh: Color(0xffede8d5),
  //     surfaceContainerHighest: Color(0xffe7e3cf),
  //   );
  // }

  // ThemeData lightHighContrast() {
  //   return theme(lightHighContrastScheme());
  // }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffd3cb00),
      onPrimary: Color(0xff343200),
      primaryContainer: Color(0xffe2d900),
      onPrimaryContainer: Color(0xff444100),
      secondary: Color(0xffcfca71),
      onSecondary: Color(0xff343200),
      secondaryContainer: Color(0xff494600),
      onSecondaryContainer: Color(0xffe5e084),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff253600),
      tertiaryContainer: Color(0xffb3e544),
      onTertiaryContainer: Color(0xff314600),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff151408),
      onSurface: Color(0xffe7e3cf),
      onSurfaceVariant: Color(0xffcbc7ab),
      outline: Color(0xff949278),
      outlineVariant: Color(0xff494832),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e3cf),
      inversePrimary: Color(0xff656100),
      // primaryFixed: Color(0xfff1e80e),
      // onPrimaryFixed: Color(0xff1e1c00),
      // primaryFixedDim: Color(0xffd3cb00),
      // onPrimaryFixedVariant: Color(0xff4c4900),
      // secondaryFixed: Color(0xffece68a),
      // onSecondaryFixed: Color(0xff1e1c00),
      // secondaryFixedDim: Color(0xffcfca71),
      // onSecondaryFixedVariant: Color(0xff4c4900),
      // tertiaryFixed: Color(0xffc0f452),
      // onTertiaryFixed: Color(0xff141f00),
      // tertiaryFixedDim: Color(0xffa5d736),
      // onTertiaryFixedVariant: Color(0xff374e00),
      // surfaceDim: Color(0xff151408),
      // surfaceBright: Color(0xff3b3a2c),
      // surfaceContainerLowest: Color(0xff0f0f05),
      // surfaceContainerLow: Color(0xff1d1c10),
      // surfaceContainer: Color(0xff212014),
      // surfaceContainerHigh: Color(0xff2c2a1e),
      // surfaceContainerHighest: Color(0xff363528),
      background: Color(0xff212014),
      onBackground: Color(0xffe7e3cf),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  // static ColorScheme darkMediumContrastScheme() {
  //   return const ColorScheme(
  //     brightness: Brightness.dark,
  //     primary: Color(0xffffffff),
  //     surfaceTint: Color(0xffd3cb00),
  //     onPrimary: Color(0xff343200),
  //     primaryContainer: Color(0xffe2d900),
  //     onPrimaryContainer: Color(0xff222000),
  //     secondary: Color(0xffd4ce74),
  //     onSecondary: Color(0xff181700),
  //     secondaryContainer: Color(0xff989441),
  //     onSecondaryContainer: Color(0xff000000),
  //     tertiary: Color(0xffffffff),
  //     onTertiary: Color(0xff253600),
  //     tertiaryContainer: Color(0xffb3e544),
  //     onTertiaryContainer: Color(0xff172300),
  //     error: Color(0xffffbab1),
  //     onError: Color(0xff370001),
  //     errorContainer: Color(0xffff5449),
  //     onErrorContainer: Color(0xff000000),
  //     surface: Color(0xff151408),
  //     onSurface: Color(0xfffffbed),
  //     onSurfaceVariant: Color(0xffcfccaf),
  //     outline: Color(0xffa7a489),
  //     outlineVariant: Color(0xff87846b),
  //     shadow: Color(0xff000000),
  //     scrim: Color(0xff000000),
  //     inverseSurface: Color(0xffe7e3cf),
  //     inversePrimary: Color(0xff4d4a00),
  //     primaryFixed: Color(0xfff1e80e),
  //     onPrimaryFixed: Color(0xff131200),
  //     primaryFixedDim: Color(0xffd3cb00),
  //     onPrimaryFixedVariant: Color(0xff3a3800),
  //     secondaryFixed: Color(0xffece68a),
  //     onSecondaryFixed: Color(0xff131200),
  //     secondaryFixedDim: Color(0xffcfca71),
  //     onSecondaryFixedVariant: Color(0xff3a3800),
  //     tertiaryFixed: Color(0xffc0f452),
  //     onTertiaryFixed: Color(0xff0b1400),
  //     tertiaryFixedDim: Color(0xffa5d736),
  //     onTertiaryFixedVariant: Color(0xff2a3c00),
  //     surfaceDim: Color(0xff151408),
  //     surfaceBright: Color(0xff3b3a2c),
  //     surfaceContainerLowest: Color(0xff0f0f05),
  //     surfaceContainerLow: Color(0xff1d1c10),
  //     surfaceContainer: Color(0xff212014),
  //     surfaceContainerHigh: Color(0xff2c2a1e),
  //     surfaceContainerHighest: Color(0xff363528),
  //   );
  // }

  // ThemeData darkMediumContrast() {
  //   return theme(darkMediumContrastScheme());
  // }

  // static ColorScheme darkHighContrastScheme() {
  //   return const ColorScheme(
  //     brightness: Brightness.dark,
  //     primary: Color(0xffffffff),
  //     surfaceTint: Color(0xffd3cb00),
  //     onPrimary: Color(0xff000000),
  //     primaryContainer: Color(0xffe2d900),
  //     onPrimaryContainer: Color(0xff000000),
  //     secondary: Color(0xfffffbed),
  //     onSecondary: Color(0xff000000),
  //     secondaryContainer: Color(0xffd4ce74),
  //     onSecondaryContainer: Color(0xff000000),
  //     tertiary: Color(0xffffffff),
  //     onTertiary: Color(0xff000000),
  //     tertiaryContainer: Color(0xffb3e544),
  //     onTertiaryContainer: Color(0xff000000),
  //     error: Color(0xfffff9f9),
  //     onError: Color(0xff000000),
  //     errorContainer: Color(0xffffbab1),
  //     onErrorContainer: Color(0xff000000),
  //     surface: Color(0xff151408),
  //     onSurface: Color(0xffffffff),
  //     onSurfaceVariant: Color(0xfffffbed),
  //     outline: Color(0xffcfccaf),
  //     outlineVariant: Color(0xffcfccaf),
  //     shadow: Color(0xff000000),
  //     scrim: Color(0xff000000),
  //     inverseSurface: Color(0xffe7e3cf),
  //     inversePrimary: Color(0xff2d2b00),
  //     primaryFixed: Color(0xfff5ec18),
  //     onPrimaryFixed: Color(0xff000000),
  //     primaryFixedDim: Color(0xffd8d000),
  //     onPrimaryFixedVariant: Color(0xff181700),
  //     secondaryFixed: Color(0xfff0eb8d),
  //     onSecondaryFixed: Color(0xff000000),
  //     secondaryFixedDim: Color(0xffd4ce74),
  //     onSecondaryFixedVariant: Color(0xff181700),
  //     tertiaryFixed: Color(0xffc4f856),
  //     onTertiaryFixed: Color(0xff000000),
  //     tertiaryFixedDim: Color(0xffa9db3b),
  //     onTertiaryFixedVariant: Color(0xff101900),
  //     surfaceDim: Color(0xff151408),
  //     surfaceBright: Color(0xff3b3a2c),
  //     surfaceContainerLowest: Color(0xff0f0f05),
  //     surfaceContainerLow: Color(0xff1d1c10),
  //     surfaceContainer: Color(0xff212014),
  //     surfaceContainerHigh: Color(0xff2c2a1e),
  //     surfaceContainerHighest: Color(0xff363528),
  //   );
  // }

  // ThemeData darkHighContrast() {
  //   return theme(darkHighContrastScheme());
  // }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
