import 'package:flutter/material.dart';

/// Sentient Shield Design System Theme
class SentientShieldTheme {
  // Prevent instantiation
  SentientShieldTheme._();

  // ---------------------------------------------------------------------------
  // COLOR SCHEME
  // ---------------------------------------------------------------------------
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFADC7FF),
    onPrimary: Color(0xFF002E68),
    primaryContainer: Color(0xFF4A8EFF),
    onPrimaryContainer: Color(0xFF00285B),
    secondary: Color(0xFFC8C6C8),
    onSecondary: Color(0xFF303032),
    secondaryContainer: Color(0xFF474649),
    onSecondaryContainer: Color(0xFFB6B4B7),
    tertiary: Color(0xFFFFB695),
    onTertiary: Color(0xFF571E00),
    tertiaryContainer: Color(0xFFEF6719),
    onTertiaryContainer: Color(0xFF4C1A00),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF131315),
    onSurface: Color(0xFFE4E2E4),
    onSurfaceVariant: Color(0xFFC1C6D7),
    outline: Color(0xFF8B90A0),
    outlineVariant: Color(0xFF414754),
    inverseSurface: Color(0xFFE4E2E4),
    onInverseSurface: Color(0xFF303032),
    inversePrimary: Color(0xFF005BC0),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  // ---------------------------------------------------------------------------
  // TYPOGRAPHY
  // ---------------------------------------------------------------------------
  static const String _fontFamily = 'NotoSans';

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      height: 40.0 / 32.0,
      letterSpacing: -0.64, // -0.02em
      color: Color(0xFFE4E2E4),
    ),
    headlineMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      height: 32.0 / 24.0,
      letterSpacing: -0.24, // -0.01em
      color: Color(0xFFE4E2E4),
    ),
    headlineSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      height: 28.0 / 20.0,
      color: Color(0xFFE4E2E4),
    ),
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 24.0 / 16.0,
      color: Color(0xFFE4E2E4),
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 20.0 / 14.0,
      color: Color(0xFFE4E2E4),
    ),
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      height: 16.0 / 12.0,
      letterSpacing: 0.6, // 0.05em
      color: Color(0xFFE4E2E4),
    ),
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: 16.0 / 12.0,
      color: Color(0xFFE4E2E4),
    ),
  );

  // ---------------------------------------------------------------------------
  // THEME DATA BUILDER
  // ---------------------------------------------------------------------------
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: const Color(0xFF131315),
      textTheme: textTheme,

      // Extension for custom tokens not covered by standard ThemeData
      extensions: const <ThemeExtension<dynamic>>[
        SentientTokens(
          surfaceDim: Color(0xFF131315),
          surfaceBright: Color(0xFF39393B),
          surfaceContainerLowest: Color(0xFF0E0E10),
          surfaceContainerLow: Color(0xFF1B1B1D),
          surfaceContainer: Color(0xFF1F1F21),
          surfaceContainerHigh: Color(0xFF2A2A2C),
          surfaceContainerHighest: Color(0xFF353437),
          statusIndicator: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 48.0,
            fontWeight: FontWeight.w700,
            height: 56.0 / 48.0,
            letterSpacing: -1.44, // -0.03em
            color: Color(0xFFE4E2E4),
          ),
          spacingBase: 4.0,
          spacingXs: 8.0,
          spacingSm: 16.0,
          spacingMd: 24.0,
          spacingLg: 32.0,
          spacingXl: 48.0,
        ),
      ],

      // Component: Primary Buttons (56px height target)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primaryContainer,
          foregroundColor: const Color(0xFFFFFFFF),
          minimumSize: const Size.fromHeight(56.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // 0.5rem
          ),
          textStyle: textTheme.labelLarge,
          elevation: 0,
        ),
      ),

      // Component: Cards
      cardTheme: CardThemeData(
        color: const Color(0xFF1F1F21),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // rounded-lg
          side: const BorderSide(
            color: Color(0xFF414754), // outline-variant border
            width: 1.0,
          ),
        ),
      ),

      // Component: Switches
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.onPrimary;
          }
          return darkColorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.primaryContainer;
          }
          return const Color(0xFF2A2A2C);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Component: Bottom Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF131315).withValues(alpha: 0.85),
        indicatorColor: darkColorScheme.primaryContainer.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: darkColorScheme.primary);
          }
          return const IconThemeData(color: Color(0xFF8B90A0));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(
              color: darkColorScheme.primary,
            );
          }
          return textTheme.labelMedium?.copyWith(
            color: const Color(0xFF8B90A0),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// THEME EXTENSION (FOR EXTRA DESIGN SYSTEM TOKENS)
// ---------------------------------------------------------------------------
@immutable
class SentientTokens extends ThemeExtension<SentientTokens> {
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final TextStyle statusIndicator;
  final double spacingBase;
  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double spacingXl;

  const SentientTokens({
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.statusIndicator,
    required this.spacingBase,
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.spacingXl,
  });

  @override
  SentientTokens copyWith({
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    TextStyle? statusIndicator,
    double? spacingBase,
    double? spacingXs,
    double? spacingSm,
    double? spacingMd,
    double? spacingLg,
    double? spacingXl,
  }) {
    return SentientTokens(
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      statusIndicator: statusIndicator ?? this.statusIndicator,
      spacingBase: spacingBase ?? this.spacingBase,
      spacingXs: spacingXs ?? this.spacingXs,
      spacingSm: spacingSm ?? this.spacingSm,
      spacingMd: spacingMd ?? this.spacingMd,
      spacingLg: spacingLg ?? this.spacingLg,
      spacingXl: spacingXl ?? this.spacingXl,
    );
  }

  @override
  SentientTokens lerp(ThemeExtension<SentientTokens>? other, double t) {
    if (other is! SentientTokens) return this;
    return SentientTokens(
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      )!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      statusIndicator: TextStyle.lerp(
        statusIndicator,
        other.statusIndicator,
        t,
      )!,
      spacingBase: lerpDouble(spacingBase, other.spacingBase, t)!,
      spacingXs: lerpDouble(spacingXs, other.spacingXs, t)!,
      spacingSm: lerpDouble(spacingSm, other.spacingSm, t)!,
      spacingMd: lerpDouble(spacingMd, other.spacingMd, t)!,
      spacingLg: lerpDouble(spacingLg, other.spacingLg, t)!,
      spacingXl: lerpDouble(spacingXl, other.spacingXl, t)!,
    );
  }

  double? lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
