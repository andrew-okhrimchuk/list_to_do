import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static const String _todoListKey = 'todo_list';
  // Сохранение данных
  static Future<void> saveToDoList(List<Map<String, dynamic>> todoList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = todoList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList(_todoListKey, stringList);
  }

  // Чтение данных
  static Future<List<Map<String, dynamic>>?> getToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? stringList = prefs.getStringList(_todoListKey);
    if (stringList != null) {
      return stringList.map((item) => jsonDecode(item)).toList().cast<Map<String, dynamic>>();
    }
    return null;
  }

  // Удаление данных
  static Future<void> removeItem(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Очистка всех данных
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
