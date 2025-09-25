// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF667EEA);
  static const Color primaryLight = Color(0xFF9FA8F2);
  static const Color primaryDark = Color(0xFF764BA2);

  // Secondary colors
  static const Color secondary = Color(0xFF4FACFE);
  static const Color secondaryLight = Color(0xFF7CC3FF);
  static const Color secondaryDark = Color(0xFF1976D2);

  // Accent colors
  static const Color accent = Color(0xFF00F2FE);
  static const Color accentLight = Color(0xFF4FFFFF);
  static const Color accentDark = Color(0xFF00BCD4);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Grey palette
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Commonly used grey aliases
  static const Color lightGrey = grey200;
  static const Color grey = grey500;
  static const Color darkGrey = grey700;

  // Text colors
  static const Color textPrimary = grey900;
  static const Color textSecondary = grey600;
  static const Color textTertiary = grey500;
  static const Color textHint = grey400;
  static const Color textDisabled = grey400;
  static const Color textOnPrimary = white;
  static const Color textOnSecondary = white;
  static const Color textOnBackground = grey900;
  static const Color textOnSurface = grey900;

  // Background colors
  static const Color background = white;
  static const Color backgroundDark = grey900;
  static const Color surface = white;
  static const Color surfaceDark = grey800;
  static const Color scaffold = grey50;
  static const Color scaffoldDark = grey900;

  // Card and container colors
  static const Color cardBackground = white;
  static const Color cardBackgroundDark = grey800;
  static const Color containerLight = grey100;
  static const Color containerDark = grey800;

  // Border and divider colors
  static const Color border = grey300;
  static const Color borderLight = grey200;
  static const Color borderDark = grey600;
  static const Color divider = grey300;
  static const Color dividerLight = grey200;
  static const Color dividerDark = grey600;

  // Shadow colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x33000000);

  // Overlay colors
  static const Color overlay = Color(0x66000000);
  static const Color overlayLight = Color(0x33000000);
  static const Color overlayDark = Color(0x80000000);

  // Gradient colors
  static const List<Color> primaryGradient = [primary, primaryDark];
  static const List<Color> secondaryGradient = [secondary, secondaryDark];
  static const List<Color> accentGradient = [accent, accentDark];
  static const List<Color> successGradient = [successLight, success];
  static const List<Color> warningGradient = [warningLight, warning];
  static const List<Color> errorGradient = [errorLight, error];

  // Special purpose colors
  static const Color onlineIndicator = success;
  static const Color offlineIndicator = grey400;
  static const Color activeIndicator = primary;
  static const Color inactiveIndicator = grey400;

  // Application specific colors
  static const Color muwasiwakiPrimary = primary;
  static const Color muwasiwakiSecondary = secondary;
  static const Color approvedStatus = success;
  static const Color pendingStatus = warning;
  static const Color rejectedStatus = error;
  static const Color memberRole = primary;
  static const Color adminRole = error;
  static const Color chairmanRole = Color(0xFF9C27B0);
  static const Color secretaryRole = Color(0xFF3F51B5);

  // Social media colors (if needed for future features)
  static const Color facebook = Color(0xFF1877F2);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color instagram = Color(0xFFE4405F);
  static const Color whatsapp = Color(0xFF25D366);
  static const Color linkedin = Color(0xFF0A66C2);

  // Utility methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  // Color schemes for different themes
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: textOnPrimary,
    secondary: secondary,
    onSecondary: textOnSecondary,
    tertiary: accent,
    onTertiary: textOnPrimary,
    error: error,
    onError: textOnPrimary,
    background: background,
    onBackground: textOnBackground,
    surface: surface,
    onSurface: textOnSurface,
    surfaceVariant: grey100,
    onSurfaceVariant: textSecondary,
    outline: border,
    outlineVariant: borderLight,
    shadow: shadow,
    scrim: overlay,
    inverseSurface: grey800,
    onInverseSurface: white,
    inversePrimary: primaryLight,
    surfaceTint: primary,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight,
    onPrimary: black,
    secondary: secondaryLight,
    onSecondary: black,
    tertiary: accentLight,
    onTertiary: black,
    error: errorLight,
    onError: black,
    background: backgroundDark,
    onBackground: white,
    surface: surfaceDark,
    onSurface: white,
    surfaceVariant: grey700,
    onSurfaceVariant: grey300,
    outline: borderDark,
    outlineVariant: grey600,
    shadow: shadowDark,
    scrim: overlayDark,
    inverseSurface: grey100,
    onInverseSurface: grey900,
    inversePrimary: primary,
    surfaceTint: primaryLight,
  );
}

// // lib/core/theme/app_colors.dart
// import 'package:flutter/material.dart';

// class AppColors {
//   static const Color primary = Color(0xFF667EEA);
//   static const Color primaryDark = Color(0xFF764BA2);
//   static const Color secondary = Color(0xFF4FACFE);
//   static const Color accent = Color(0xFF00F2FE);

//   // Status colors
//   static const Color success = Color(0xFF4CAF50);
//   static const Color warning = Color(0xFFFF9800);
//   static const Color error = Color(0xFFF44336);
//   static const Color info = Color(0xFF2196F3);

//   // Neutral colors
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color black = Color(0xFF000000);
//   static const Color grey = Color(0xFF9E9E9E);
//   static const Color lightGrey = Color(0xFFF5F5F5);
//   static const Color darkGrey = Color(0xFF424242);

//   // Text colors
//   static const Color textPrimary = Color(0xFF212121);
//   static const Color textSecondary = Color(0xFF757575);
//   static const Color textHint = Color(0xFFBDBDBD);
// }
