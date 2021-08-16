import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  void toggleMode() async {
    // light index = 1; dark index = 2
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', _mode.index);
    notifyListeners();
  }
}
