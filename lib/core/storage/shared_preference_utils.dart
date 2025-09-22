import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper – add more getters / setters when needed.
abstract class SharedPrefsService {
  static const String _keyUserId = 'userId';

  static Future<void> storeUserId(String uid) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_keyUserId, uid);
  }

  static Future<String?> getUserId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_keyUserId);
  }

  static Future<void> clearUserId() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_keyUserId);
  }
}
