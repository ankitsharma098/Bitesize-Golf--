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
  Future<void> clear();
  Future<bool> isLoggedIn();
  Future<String?> getUserRole();
  Future<String?> getUserId();
  Future<bool> isProfileCompleted();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  final HiveStorageService hiveStorage;

  AuthLocalDataSourceImpl({required this.prefs, required this.hiveStorage});

  @override
  Future<void> cacheUser(UserModel user) async {
    // Store essential user data in SharedPreferences for quick access
    await Future.wait([
      prefs.setBool(IS_LOGGED_IN, true),
      prefs.setString(PREF_USER_ID, user.uid),
      prefs.setString(PREF_USER_EMAIL, user.email ?? ''),
      prefs.setString(PREF_USER_ROLE, user.role),
      prefs.setBool(PREF_EMAIL_VERIFIED, user.emailVerified),
      prefs.setBool(PREF_PROFILE_COMPLETED, user.profileCompleted),
      if (user.displayName != null)
        prefs.setString(PREF_USER_NAME, user.displayName!),
      if (user.firstName != null)
        prefs.setString(PREF_USER_FIRST_NAME, user.firstName!),
      if (user.lastName != null)
        prefs.setString(PREF_USER_LAST_NAME, user.lastName!),
      if (user.photoURL != null)
        prefs.setString(PREF_USER_PHOTO, user.photoURL!),
      prefs.setString(PREF_ACCOUNT_STATUS, user.accountStatus),
    ]);

    // Store subscription info if available

    // Store complete user data in Hive for complex operations
    try {
      // Convert to JSON string first to ensure proper serialization
      final userJson = user.toJson();
      await hiveStorage.store(
        HiveBoxes.authBox,
        HiveKeys.userCredentials,
        userJson,
      );
    } catch (e) {
      // Log error but don't fail the operation
      print('Failed to cache user in Hive: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      // First try to get from Hive (complete data)
      final userData = await hiveStorage.retrieve<dynamic>(
        HiveBoxes.authBox,
        HiveKeys.userCredentials,
      );

      if (userData != null) {
        // Handle different data types returned from Hive
        Map<String, dynamic> userMap;

        if (userData is Map<String, dynamic>) {
          userMap = userData;
        } else if (userData is Map<dynamic, dynamic>) {
          // Convert Map<dynamic, dynamic> to Map<String, dynamic>
          userMap = Map<String, dynamic>.from(userData);
        } else if (userData is String) {
          // If stored as JSON string, parse it
          userMap = json.decode(userData) as Map<String, dynamic>;
        } else {
          print('Unexpected userData type: ${userData.runtimeType}');
          return _getUserFromPreferences();
        }

        return UserModel.fromJson(userMap);
      }

      // Fallback: reconstruct from SharedPreferences
      return _getUserFromPreferences();
    } catch (e) {
      print('Error retrieving user from Hive: $e');
      // Fallback to SharedPreferences
      return _getUserFromPreferences();
    }
  }

  Future<UserModel?> _getUserFromPreferences() async {
    try {
      final userId = prefs.getString(PREF_USER_ID);
      if (userId == null) return null;

      // Build UserModel from SharedPreferences data
      return UserModel(
        uid: userId,
        email: prefs.getString(PREF_USER_EMAIL),
        displayName: prefs.getString(PREF_USER_NAME),
        photoURL: prefs.getString(PREF_USER_PHOTO),
        role: prefs.getString(PREF_USER_ROLE) ?? 'parent',
        emailVerified: prefs.getBool(PREF_EMAIL_VERIFIED) ?? false,
        firstName: prefs.getString(PREF_USER_FIRST_NAME),
        lastName: prefs.getString(PREF_USER_LAST_NAME),
        accountStatus: prefs.getString(PREF_ACCOUNT_STATUS) ?? 'active',
        profileCompleted: prefs.getBool(PREF_PROFILE_COMPLETED) ?? false,
        preferences: null, // Will be loaded separately if needed
        createdAt: DateTime.now(), // Placeholder
        updatedAt: DateTime.now(), // Placeholder
      );
    } catch (e) {
      print('Error retrieving user from SharedPreferences: $e');
      return null;
    }
  }

  @override
  Future<void> clear() async {
    // Clear SharedPreferences auth data
    final keysToRemove = [
      IS_LOGGED_IN,
      PREF_USER_ID,
      PREF_USER_EMAIL,
      PREF_USER_NAME,
      PREF_USER_FIRST_NAME,
      PREF_USER_LAST_NAME,
      PREF_USER_PHOTO,
      PREF_USER_ROLE,
      PREF_EMAIL_VERIFIED,
      PREF_PROFILE_COMPLETED,
      PREF_ACCOUNT_STATUS,
      PREF_SUBSCRIPTION_STATUS,
      PREF_SUBSCRIPTION_TIER,
      PREF_SUBSCRIPTION_AUTO_RENEW,
    ];

    await Future.wait([...keysToRemove.map((key) => prefs.remove(key))]);

    // Clear relevant Hive boxes
    try {
      await Future.wait([
        hiveStorage.clearBox(HiveBoxes.authBox),
        hiveStorage.clearBox(HiveBoxes.userProfileBox),
      ]);
    } catch (e) {
      print('Error clearing Hive storage: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final isLoggedInPref = prefs.getBool(IS_LOGGED_IN) ?? false;
    final hasUserId = prefs.getString(PREF_USER_ID) != null;

    // Both conditions should be true for a valid logged-in state
    return isLoggedInPref && hasUserId;
  }

  @override
  Future<String?> getUserRole() async {
    return prefs.getString(PREF_USER_ROLE);
  }

  @override
  Future<String?> getUserId() async {
    return prefs.getString(PREF_USER_ID);
  }

  @override
  Future<bool> isProfileCompleted() async {
    return prefs.getBool(PREF_PROFILE_COMPLETED) ?? false;
  }

  // Helper method to update profile completion status
  Future<void> updateProfileCompletion(bool completed) async {
    await prefs.setBool(PREF_PROFILE_COMPLETED, completed);

    // Also update in Hive if user exists
    try {
      final userData = await hiveStorage.retrieve<dynamic>(
        HiveBoxes.authBox,
        HiveKeys.userCredentials,
      );

      if (userData != null) {
        Map<String, dynamic> userMap;

        if (userData is Map<String, dynamic>) {
          userMap = userData;
        } else if (userData is Map<dynamic, dynamic>) {
          userMap = Map<String, dynamic>.from(userData);
        } else if (userData is String) {
          userMap = json.decode(userData) as Map<String, dynamic>;
        } else {
          return;
        }

        userMap['profileCompleted'] = completed;
        userMap['updatedAt'] = DateTime.now().toIso8601String();

        await hiveStorage.store(
          HiveBoxes.authBox,
          HiveKeys.userCredentials,
          userMap,
        );
      }
    } catch (e) {
      print('Error updating profile completion in Hive: $e');
    }
  }
}
