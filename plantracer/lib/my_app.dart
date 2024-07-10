import 'package:flutter/material.dart';
import 'my_home_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ValueNotifier<ThemeMode> _themeModeNotifier =
      ValueNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: MyAppThemes.lightTheme,
          darkTheme: MyAppThemes.darkTheme,
          themeMode: themeMode,
          home: MyHomePage(
            title: 'Plantracer',
            themeModeNotifier: _themeModeNotifier,
          ),
        );
      },
    );
  }
}

class MyAppThemes {
  static final lightTheme = ThemeData(
      primaryColor: Colors.white,
      focusColor: Colors.red,
      primaryColorDark: Colors.green,
      brightness: Brightness.light,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
      ),
      fontFamily: 'Sohne');

  static final darkTheme = ThemeData(
      primaryColor: Colors.black,
      primaryColorLight: Colors.black,
      primaryColorDark: Colors.white,
      brightness: Brightness.dark,
      fontFamily: 'Sohne');
}
