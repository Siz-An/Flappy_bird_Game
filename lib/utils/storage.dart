// utils/storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const String highScoreKey = 'highScore';

  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(highScoreKey, score);
  }

  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(highScoreKey) ?? 0;
  }
}
