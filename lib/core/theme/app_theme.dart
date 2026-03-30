import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  CAB APP — Brand Color System
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppColors {
  static const Color yellow         = Color(0xFFFFD600);
  static const Color yellowLight    = Color(0xFFFFE566);
  static const Color yellowDark     = Color(0xFFCCAB00);
  static const Color yellowSurface  = Color(0x1AFFD600);

  static const Color darkBg         = Color(0xFF0A0A0A);
  static const Color darkBg2        = Color(0xFF141414);
  static const Color darkCard       = Color(0xFF1C1C1C);
  static const Color darkSurface    = Color(0xFF242424);
  static const Color darkBorder     = Color(0xFF2C2C2C);
  static const Color darkBorder2    = Color(0xFF3A3A3A);
  static const Color darkTextSec    = Color(0xFF8A8A8A);
  static const Color darkTextTer    = Color(0xFF555555);

  static const Color lightBg        = Color(0xFFF8F8F8);
  static const Color lightBg2       = Color(0xFFF0F0F0);
  static const Color lightCard      = Color(0xFFFFFFFF);
  static const Color lightSurface   = Color(0xFFF4F4F4);
  static const Color lightBorder    = Color(0xFFE8E8E8);
  static const Color lightBorder2   = Color(0xFFD0D0D0);
  static const Color lightTextSec   = Color(0xFF6B6B6B);
  static const Color lightTextTer   = Color(0xFFAAAAAA);

  static const Color black          = Color(0xFF000000);
  static const Color white          = Color(0xFFFFFFFF);

  static const Color success        = Color(0xFF22C55E);
  static const Color successSurface = Color(0x1A22C55E);
  static const Color error          = Color(0xFFEF4444);
  static const Color errorSurface   = Color(0x1AEF4444);
  static const Color warning        = Color(0xFFF97316);
  static const Color warningSurface = Color(0x1AF97316);
  static const Color info           = Color(0xFF3B82F6);
  static const Color infoSurface    = Color(0x1A3B82F6);

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':      return error;
      case 'upcoming':  return info;
      case 'finished':  return darkTextSec;
      case 'pending':   return warning;
      case 'confirmed': return success;
      case 'shipped':   return info;
      case 'delivered': return success;
      case 'cancelled': return error;
      default:          return darkTextSec;
    }
  }

  static Color statusSurface(String status) {
    switch (status.toLowerCase()) {
      case 'live':      return errorSurface;
      case 'upcoming':  return infoSurface;
      case 'finished':  return const Color(0x1A8A8A8A);
      case 'pending':   return warningSurface;
      case 'confirmed': return successSurface;
      case 'shipped':   return infoSurface;
      case 'delivered': return successSurface;
      case 'cancelled': return errorSurface;
      default:          return const Color(0x1A8A8A8A);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Typography
// ─────────────────────────────────────────────────────────────────────────────
TextTheme _buildTextTheme({required bool dark}) {
  final primary   = dark ? AppColors.white       : AppColors.black;
  final secondary = dark ? AppColors.darkTextSec  : AppColors.lightTextSec;

  return TextTheme(
    displayLarge:  TextStyle(fontFamily: 'Rajdhani', fontSize: 64, fontWeight: FontWeight.w700, color: primary, letterSpacing: -2, height: 0.95),
    displayMedium: TextStyle(fontFamily: 'Rajdhani', fontSize: 48, fontWeight: FontWeight.w700, color: primary, letterSpacing: -1),
    displaySmall:  TextStyle(fontFamily: 'Rajdhani', fontSize: 36, fontWeight: FontWeight.w700, color: primary),
    headlineLarge: TextStyle(fontFamily: 'Rajdhani', fontSize: 28, fontWeight: FontWeight.w700, color: primary, letterSpacing: 0.2),
    headlineMedium:TextStyle(fontFamily: 'Rajdhani', fontSize: 22, fontWeight: FontWeight.w600, color: primary),
    headlineSmall: TextStyle(fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w600, color: primary),
    titleLarge:    TextStyle(fontFamily: 'Inter',    fontSize: 16, fontWeight: FontWeight.w600, color: primary),
    titleMedium:   TextStyle(fontFamily: 'Inter',    fontSize: 14, fontWeight: FontWeight.w500, color: primary),
    titleSmall:    TextStyle(fontFamily: 'Inter',    fontSize: 12, fontWeight: FontWeight.w500, color: primary),
    bodyLarge:     TextStyle(fontFamily: 'Inter',    fontSize: 15, fontWeight: FontWeight.w400, color: primary,   height: 1.6),
    bodyMedium:    TextStyle(fontFamily: 'Inter',    fontSize: 13, fontWeight: FontWeight.w400, color: secondary, height: 1.5),
    bodySmall:     TextStyle(fontFamily: 'Inter',    fontSize: 12, fontWeight: FontWeight.w400, color: secondary),
    labelLarge:    TextStyle(fontFamily: 'Rajdhani', fontSize: 15, fontWeight: FontWeight.w700, color: primary,   letterSpacing: 0.6),
    labelMedium:   TextStyle(fontFamily: 'Inter',    fontSize: 12, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 0.3),
    labelSmall:    TextStyle(fontFamily: 'Inter',    fontSize: 10, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 0.5),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  DARK THEME
// ─────────────────────────────────────────────────────────────────────────────
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBg,
  primaryColor: AppColors.yellow,
  splashFactory: InkRipple.splashFactory,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.yellow, onPrimary: AppColors.black,
    primaryContainer: Color(0xFF2A2400), onPrimaryContainer: AppColors.yellow,
    secondary: AppColors.yellowDark, onSecondary: AppColors.black,
    surface: AppColors.darkCard, onSurface: AppColors.white,
    surfaceVariant: AppColors.darkSurface, onSurfaceVariant: AppColors.darkTextSec,
    background: AppColors.darkBg, onBackground: AppColors.white,
    outline: AppColors.darkBorder, outlineVariant: AppColors.darkBorder2,
    error: AppColors.error, onError: AppColors.white,
  ),
  textTheme: _buildTextTheme(dark: true),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBg,
    foregroundColor: AppColors.white,
    elevation: 0, scrolledUnderElevation: 0, centerTitle: false,
    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
    iconTheme: IconThemeData(color: AppColors.white, size: 22),
    actionsIconTheme: IconThemeData(color: AppColors.white, size: 22),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkBg2,
    selectedItemColor: AppColors.yellow,
    unselectedItemColor: AppColors.darkTextSec,
    showSelectedLabels: true, showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed, elevation: 0,
    selectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 10),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.yellow, foregroundColor: AppColors.black,
      elevation: 0, shadowColor: Colors.transparent,
      textStyle: const TextStyle(fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: const Size(double.infinity, 52),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.yellow,
      side: const BorderSide(color: AppColors.yellow, width: 1.5),
      textStyle: const TextStyle(fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: const Size(double.infinity, 52),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.yellow,
      textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true, fillColor: AppColors.darkSurface,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.darkBorder)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.darkBorder, width: 0.5)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.yellow, width: 1.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
    hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.darkTextSec),
    labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.darkTextSec),
    floatingLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.yellow, fontWeight: FontWeight.w500),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    prefixIconColor: AppColors.darkTextSec,
    suffixIconColor: AppColors.darkTextSec,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.darkSurface, selectedColor: AppColors.yellowSurface,
    checkmarkColor: AppColors.yellow,
    side: const BorderSide(color: AppColors.darkBorder, width: 0.5),
    labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.white),
    secondaryLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.yellow),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 0.5, space: 0),
  listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4), minVerticalPadding: 12),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? AppColors.black : AppColors.darkTextSec),
    trackColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? AppColors.yellow : AppColors.darkSurface),
    trackOutlineColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? Colors.transparent : AppColors.darkBorder),
  ),
  iconTheme: const IconThemeData(color: AppColors.white, size: 22),
  iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: AppColors.white)),
);

// ─────────────────────────────────────────────────────────────────────────────
//  LIGHT THEME
// ─────────────────────────────────────────────────────────────────────────────
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBg,
  primaryColor: AppColors.yellow,
  splashFactory: InkRipple.splashFactory,
  colorScheme: const ColorScheme.light(
    primary: AppColors.yellow, onPrimary: AppColors.black,
    primaryContainer: Color(0xFFFFF9C4), onPrimaryContainer: Color(0xFF332B00),
    secondary: AppColors.yellowDark, onSecondary: AppColors.black,
    surface: AppColors.lightCard, onSurface: AppColors.black,
    surfaceVariant: AppColors.lightSurface, onSurfaceVariant: AppColors.lightTextSec,
    background: AppColors.lightBg, onBackground: AppColors.black,
    outline: AppColors.lightBorder, outlineVariant: AppColors.lightBorder2,
    error: AppColors.error, onError: AppColors.white,
  ),
  textTheme: _buildTextTheme(dark: false),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightCard,
    foregroundColor: AppColors.black,
    elevation: 0, scrolledUnderElevation: 0, centerTitle: false,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
    iconTheme: IconThemeData(color: AppColors.black, size: 22),
    actionsIconTheme: IconThemeData(color: AppColors.black, size: 22),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightCard,
    selectedItemColor: AppColors.black,
    unselectedItemColor: AppColors.lightTextSec,
    showSelectedLabels: true, showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed, elevation: 0,
    selectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 10),
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.yellow, foregroundColor: AppColors.black,
      elevation: 0, shadowColor: Colors.transparent,
      textStyle: const TextStyle(fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: const Size(double.infinity, 52),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.black,
      side: const BorderSide(color: AppColors.black, width: 1.5),
      textStyle: const TextStyle(fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: const Size(double.infinity, 52),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.black,
      textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true, fillColor: AppColors.lightCard,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.lightBorder)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.lightBorder, width: 0.5)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.black, width: 1.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
    hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSec),
    labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSec),
    floatingLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.black, fontWeight: FontWeight.w500),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    prefixIconColor: AppColors.lightTextSec,
    suffixIconColor: AppColors.lightTextSec,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.lightSurface, selectedColor: AppColors.yellowSurface,
    checkmarkColor: AppColors.yellowDark,
    side: const BorderSide(color: AppColors.lightBorder, width: 0.5),
    labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.black),
    secondaryLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.yellowDark),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  dividerTheme: const DividerThemeData(color: AppColors.lightBorder, thickness: 0.5, space: 0),
  listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4), minVerticalPadding: 12),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? AppColors.black : AppColors.lightTextSec),
    trackColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? AppColors.yellow : AppColors.lightSurface),
    trackOutlineColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? Colors.transparent : AppColors.lightBorder),
  ),
  iconTheme: const IconThemeData(color: AppColors.black, size: 22),
  iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: AppColors.black)),
);