import 'package:flutter/foundation.dart';
import '../controllers/theme_controller.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeController _themeController = ThemeController();
  
  bool get isDarkMode => _themeController.isDarkMode;

  Future<void> loadTheme() async {
    await _themeController.loadTheme();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    await _themeController.toggleTheme();
    notifyListeners();
  }
}