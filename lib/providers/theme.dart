import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  void toggleMode() async {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // light index = 1; dark index = 2
    await prefs.setInt('theme', _mode.index);

    notifyListeners();
  }
}
