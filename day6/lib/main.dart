import 'package:day6/pages/HomePage.dart';
import 'package:day6/themes/AppThemeData.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final themeKey = pref.getString('selectedTheme') ?? 'blue';
  final isDark = pref.getBool('isDark') ?? false;
  runApp(MyApp(initThemeKey: themeKey, initDarkMode: isDark));
}

class MyApp extends StatefulWidget {
  final String initThemeKey;
  final bool initDarkMode;

  const MyApp({
    super.key,
    this.initThemeKey = 'blue',
    this.initDarkMode = false,
  });

  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late String themeKey;
  late bool isDark;

  @override
  void initState() {
    super.initState();
    themeKey = widget.initThemeKey;
    isDark = widget.initDarkMode;
  }

  void toggleDarkMode() async {
    final pref = await SharedPreferences.getInstance();
    isDark = !isDark;
    await pref.setBool('isDark', isDark);
    setState(() {});
  }

  void changeTheme(String newThemeKey) async {
    setState(() {
      themeKey = newThemeKey;
      // Here you can add logic to change the theme based on the newThemeKey
      // For example, you might want to load a different theme color or style.
    });
    final pref = await SharedPreferences.getInstance();
    await pref.setString('selectedTheme', themeKey);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = AppTheme.getTheme(themeKey, isDark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: themeData.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: themeData.lightTheme,
      home: HomePage(
        onToggleDarkMode: toggleDarkMode,
        currentThemeKey: themeKey,
        onChangeTheme: changeTheme,       
      ),
    );
  }
}
