import 'package:flutter/material.dart';

class AppThemeData {
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  AppThemeData({required this.lightTheme, required this.darkTheme});
}

class AppTheme {
  static final Map<String, Color> themeSeeds = {
    'blue': Colors.blue,
    'red': Colors.red,
    'green': Colors.green,
    'purple': Colors.purple,
    'orange': Colors.orange,
    'pink': Colors.pink,
  };

  static AppThemeData getTheme(String key, bool isDark) {
    final seed = themeSeeds[key] ?? Colors.blue;
    final light = ThemeData(
      colorSchemeSeed: seed,
      brightness: Brightness.light,
      useMaterial3: true    );
    final dark = ThemeData(
      colorSchemeSeed: seed,
      brightness: Brightness.dark,
      useMaterial3: true,
    );
    return AppThemeData(lightTheme: light, darkTheme: dark);
  }
  static List<String> get availableTheme => themeSeeds.keys.toList();
}
