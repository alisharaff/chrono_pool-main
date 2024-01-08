

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String player1Key = 'player1';
  static const String player2Key = 'player2';

  static Future<void> savePlayer1Name(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(player1Key, name);
  }

  static Future<void> savePlayer2Name(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(player2Key, name);
  }

  static Future<String?> getPlayer1Name() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(player1Key);
  }

  static Future<String?> getPlayer2Name() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(player2Key);
  }
}