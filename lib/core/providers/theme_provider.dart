import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'cab_theme_mode';
  final SharedPreferences _prefs;

  late ThemeMode _themeMode;

  ThemeProvider(this._prefs) {
    final stored = _prefs.getString(_key);
    _themeMode = stored == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    _prefs.setString(_key, isDark ? 'dark' : 'light');
    notifyListeners();
  }

  void setMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}