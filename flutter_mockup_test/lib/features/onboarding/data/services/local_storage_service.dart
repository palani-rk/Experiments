import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyPrefix = 'questionnaire_';
  
  Future<void> saveData(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString('$_keyPrefix$key', jsonString);
  }
  
  Future<Map<String, dynamic>?> loadData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_keyPrefix$key');
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }
  
  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$key');
  }
  
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}