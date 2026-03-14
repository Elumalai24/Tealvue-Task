import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/portfolio_model.dart';

class StorageService {
  static const String _portfolioKey = 'portfolio_items';
  static const String _darkModeKey = 'dark_mode';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<PortfolioItem>> loadPortfolio() async {
    await init();
    final jsonStr = _prefs!.getString(_portfolioKey);
    if (jsonStr == null) return [];

    try {
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list
          .map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> savePortfolio(List<PortfolioItem> items) async {
    await init();
    final jsonStr = json.encode(items.map((e) => e.toJson()).toList());
    await _prefs!.setString(_portfolioKey, jsonStr);
  }

  Future<bool> loadDarkMode() async {
    await init();
    return _prefs!.getBool(_darkModeKey) ?? false;
  }

  Future<void> saveDarkMode(bool isDark) async {
    await init();
    await _prefs!.setBool(_darkModeKey, isDark);
  }
}
