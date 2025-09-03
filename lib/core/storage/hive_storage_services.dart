import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';

import 'hive_storage_constants.dart';

abstract class HiveStorageService {
  // Generic operations
  Future<void> store<T>(String boxName, String key, T value);
  Future<T?> retrieve<T>(String boxName, String key);
  Future<void> delete(String boxName, String key);
  Future<void> clearBox(String boxName);

  // Specialized operations
  Future<void> storeUserProfile(Map<String, dynamic> profile);
  Future<Map<String, dynamic>?> getUserProfile();
  Future<void> storeProgress(Map<String, dynamic> progress);
  Future<Map<String, dynamic>?> getProgress();
}

@LazySingleton(as: HiveStorageService)
class HiveStorageServiceImpl implements HiveStorageService {
  static final Map<String, Box> _boxes = {};

  Future<Box> _getBox(String boxName) async {
    if (_boxes.containsKey(boxName)) {
      return _boxes[boxName]!;
    }

    final box = await Hive.openBox(boxName);
    _boxes[boxName] = box;
    return box;
  }

  @override
  Future<void> store<T>(String boxName, String key, T value) async {
    final box = await _getBox(boxName);
    await box.put(key, value);
  }

  @override
  Future<T?> retrieve<T>(String boxName, String key) async {
    final box = await _getBox(boxName);
    return box.get(key) as T?;
  }

  @override
  Future<void> delete(String boxName, String key) async {
    final box = await _getBox(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clearBox(String boxName) async {
    final box = await _getBox(boxName);
    await box.clear();
  }

  @override
  Future<void> storeUserProfile(Map<String, dynamic> profile) async {
    // Store based on user role
    final role = profile['role'] as String?;

    if (role == 'pupil') {
      await store(HiveBoxes.userProfileBox, HiveKeys.pupilProfile, profile);
    } else if (role == 'coach') {
      await store(HiveBoxes.userProfileBox, HiveKeys.coachProfile, profile);
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile() async {
    // Try to get pupil profile first, then coach
    var profile = await retrieve<Map<String, dynamic>>(
      HiveBoxes.userProfileBox,
      HiveKeys.pupilProfile,
    );

    profile ??= await retrieve<Map<String, dynamic>>(
      HiveBoxes.userProfileBox,
      HiveKeys.coachProfile,
    );

    return profile;
  }

  @override
  Future<void> storeProgress(Map<String, dynamic> progress) async {
    await store(HiveBoxes.progressBox, HiveKeys.learningProgress, progress);
  }

  @override
  Future<Map<String, dynamic>?> getProgress() async {
    return await retrieve<Map<String, dynamic>>(
      HiveBoxes.progressBox,
      HiveKeys.learningProgress,
    );
  }
}
