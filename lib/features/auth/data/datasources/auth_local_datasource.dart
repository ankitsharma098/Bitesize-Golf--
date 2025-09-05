import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/hive_storage_constants.dart';
import '../../../../core/storage/hive_storage_services.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> cacheFullUserProfile(Map<String, dynamic> profile);
  Future<Map<String, dynamic>?> getFullUserProfile();
  Future<void> clear();
  Future<bool> isLoggedIn();
  Future<String?> getUserRole();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  final HiveStorageService hiveStorage;

  AuthLocalDataSourceImpl({required this.prefs, required this.hiveStorage});

  @override
  Future<void> cacheUser(UserModel user) async {
    // Store minimal data in SharedPreferences for quick access
    await Future.wait([
      prefs.setBool(IS_LOGGED_IN, true),
      prefs.setString(PREF_USER_ID, user.uid),
      prefs.setString(PREF_USER_NAME, user.displayName ?? ''),
      prefs.setString(PREF_USER_EMAIL, user.email ?? ''),
      prefs.setString(PREF_USER_PHOTO, user.photoURL ?? ''),
      prefs.setString(PREF_USER_ROLE, user.role),
      prefs.setBool(PREF_EMAIL_VERIFIED, user.emailVerified),
    ]);

    // Store full user data in Hive for complex operations
    await hiveStorage.store(
      HiveBoxes.authBox,
      HiveKeys.userCredentials,
      user.toJson(),
    );
  }

  @override
  Future<UserModel?> getUser() async {
    final userData = await hiveStorage.retrieve<Map<String, dynamic>>(
      HiveBoxes.authBox,
      HiveKeys.userCredentials,
    );

    if (userData == null) return null;
    return UserModel.fromJson(userData);
  }

  @override
  Future<void> cacheFullUserProfile(Map<String, dynamic> profile) async {
    // Update SharedPrefs with critical info
    final subscription = profile['subscription'] as Map<String, dynamic>?;
    if (subscription != null) {
      await prefs.setString(
        PREF_SUBSCRIPTION_STATUS,
        subscription['status'] ?? 'free',
      );
      await prefs.setString(
        PREF_SUBSCRIPTION_TIER,
        subscription['tier'] ?? 'free',
      );
    }

    // Store full profile in Hive
    await hiveStorage.storeUserProfile(profile);
  }

  @override
  Future<Map<String, dynamic>?> getFullUserProfile() async {
    return await hiveStorage.getUserProfile();
  }

  @override
  Future<void> clear() async {
    // Clear SharedPreferences
    await prefs.clear();

    // Clear all Hive boxes
    await Future.wait([
      hiveStorage.clearBox(HiveBoxes.authBox),
      hiveStorage.clearBox(HiveBoxes.userProfileBox),
      hiveStorage.clearBox(HiveBoxes.contentCacheBox),
      hiveStorage.clearBox(HiveBoxes.progressBox),
    ]);
  }

  @override
  Future<bool> isLoggedIn() async {
    return prefs.getBool(IS_LOGGED_IN) ?? false;
  }

  @override
  Future<String?> getUserRole() async {
    return prefs.getString(PREF_USER_ROLE);
  }
}
