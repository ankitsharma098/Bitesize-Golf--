// lib/core/services/pupil_progress_service.dart
import 'package:bitesize_golf/core/utils/user_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Models/pupil model/level_progress.dart';
import '../constants/firebase_collections_names.dart';

class PupilProgressService {
  final UserUtil _userUtil = UserUtil();

  /// Update book completion in pupil's level progress
  Future<void> updateBookCompletion(int levelNumber) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('Pupil not found');

      // Get current level progress or create new one
      final currentProgress =
          pupil.levelProgress[levelNumber] ?? LevelProgress.initial();

      // Increment books completed
      final updatedProgress = currentProgress.copyWith(
        booksCompleted: currentProgress.booksCompleted + 1,
        lastActivity: DateTime.now(),
      );

      // Update pupil model with new progress
      final updatedLevelProgress = Map<int, LevelProgress>.from(
        pupil.levelProgress,
      );
      updatedLevelProgress[levelNumber] = updatedProgress;

      // Update in Firestore
      await FirestoreCollections.pupilsCol.doc(pupil.id).update({
        'levelProgress': updatedLevelProgress.map(
          (k, v) => MapEntry(k.toString(), v.toJson()),
        ),
        'lastActivityDate': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update book completion: $e');
    }
  }

  /// Update quiz completion in pupil's level progress
  Future<void> updateQuizCompletion(int levelNumber, double score) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('Pupil not found');

      // Get current level progress or create new one
      final currentProgress =
          pupil.levelProgress[levelNumber] ?? LevelProgress.initial();

      // Calculate new average score
      final totalQuizzes = currentProgress.quizzesCompleted + 1;
      final newAverageScore = totalQuizzes > 1
          ? ((currentProgress.averageScore * currentProgress.quizzesCompleted) +
                    score) /
                totalQuizzes
          : score;

      // Increment quizzes completed
      final updatedProgress = currentProgress.copyWith(
        quizzesCompleted: totalQuizzes,
        averageScore: newAverageScore,
        lastActivity: DateTime.now(),
      );

      // Update pupil model with new progress
      final updatedLevelProgress = Map<int, LevelProgress>.from(
        pupil.levelProgress,
      );
      updatedLevelProgress[levelNumber] = updatedProgress;

      // Update global quiz stats
      final globalQuizzesCompleted = pupil.totalQuizzesCompleted + 1;
      final newGlobalAverageScore = globalQuizzesCompleted > 1
          ? ((pupil.averageQuizScore * pupil.totalQuizzesCompleted) + score) /
                globalQuizzesCompleted
          : score;

      // Update in Firestore
      await FirestoreCollections.pupilsCol.doc(pupil.id).update({
        'levelProgress': updatedLevelProgress.map(
          (k, v) => MapEntry(k.toString(), v.toJson()),
        ),
        'totalQuizzesCompleted': globalQuizzesCompleted,
        'averageQuizScore': newGlobalAverageScore,
        'lastActivityDate': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update quiz completion: $e');
    }
  }

  /// Update challenge completion in pupil's level progress
  Future<void> updateChallengeCompletion(int levelNumber) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('Pupil not found');

      // Get current level progress or create new one
      final currentProgress =
          pupil.levelProgress[levelNumber] ?? LevelProgress.initial();

      // Increment challenges completed
      final updatedProgress = currentProgress.copyWith(
        challengesDone: currentProgress.challengesDone + 1,
        lastActivity: DateTime.now(),
      );

      // Update pupil model with new progress
      final updatedLevelProgress = Map<int, LevelProgress>.from(
        pupil.levelProgress,
      );
      updatedLevelProgress[levelNumber] = updatedProgress;

      // Update global challenge stats
      final globalChallengesCompleted = pupil.totalChallengesCompleted + 1;

      // Update in Firestore
      await FirestoreCollections.pupilsCol.doc(pupil.id).update({
        'levelProgress': updatedLevelProgress.map(
          (k, v) => MapEntry(k.toString(), v.toJson()),
        ),
        'totalChallengesCompleted': globalChallengesCompleted,
        'lastActivityDate': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update challenge completion: $e');
    }
  }

  /// Update game completion in pupil's level progress
  Future<void> updateGameCompletion(int levelNumber) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('Pupil not found');

      // Get current level progress or create new one
      final currentProgress =
          pupil.levelProgress[levelNumber] ?? LevelProgress.initial();

      // Increment games completed
      final updatedProgress = currentProgress.copyWith(
        gamesDone: currentProgress.gamesDone + 1,
        lastActivity: DateTime.now(),
      );

      // Update pupil model with new progress
      final updatedLevelProgress = Map<int, LevelProgress>.from(
        pupil.levelProgress,
      );
      updatedLevelProgress[levelNumber] = updatedProgress;

      // Update in Firestore
      await FirestoreCollections.pupilsCol.doc(pupil.id).update({
        'levelProgress': updatedLevelProgress.map(
          (k, v) => MapEntry(k.toString(), v.toJson()),
        ),
        'lastActivityDate': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update game completion: $e');
    }
  }

  /// Check if level is completed based on progress
  Future<bool> checkLevelCompletion(int levelNumber) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) return false;

      final levelProgress = pupil.levelProgress[levelNumber];
      if (levelProgress == null) return false;

      // Define completion criteria (you can adjust these)
      const minBooksCompleted = 1;
      const minQuizzesCompleted = 1;
      const minChallengesCompleted = 1;
      const minGamesCompleted = 1;

      return levelProgress.booksCompleted >= minBooksCompleted &&
          levelProgress.quizzesCompleted >= minQuizzesCompleted &&
          levelProgress.challengesDone >= minChallengesCompleted &&
          levelProgress.gamesDone >= minGamesCompleted;
    } catch (e) {
      throw Exception('Failed to check level completion: $e');
    }
  }

  /// Mark level as completed
  Future<void> completeLevelProgress(int levelNumber) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('Pupil not found');

      // Get current level progress or create new one
      final currentProgress =
          pupil.levelProgress[levelNumber] ?? LevelProgress.initial();

      // Mark as completed
      final updatedProgress = currentProgress.copyWith(
        isCompleted: true,
        lastActivity: DateTime.now(),
      );

      // Update pupil model with new progress
      final updatedLevelProgress = Map<int, LevelProgress>.from(
        pupil.levelProgress,
      );
      updatedLevelProgress[levelNumber] = updatedProgress;

      // Unlock next level if not already unlocked
      final updatedUnlockedLevels = List<int>.from(pupil.unlockedLevels);
      final nextLevel = levelNumber + 1;
      if (!updatedUnlockedLevels.contains(nextLevel) && nextLevel <= 10) {
        updatedUnlockedLevels.add(nextLevel);
      }

      // Update in Firestore
      await FirestoreCollections.pupilsCol.doc(pupil.id).update({
        'levelProgress': updatedLevelProgress.map(
          (k, v) => MapEntry(k.toString(), v.toJson()),
        ),
        'unlockedLevels': updatedUnlockedLevels,
        'currentLevel': nextLevel <= 10 ? nextLevel : pupil.currentLevel,
        'lastActivityDate': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to complete level progress: $e');
    }
  }

  /// Add XP to pupil
  Future<void> addXP(int xpAmount) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('Pupil not found');

      final newTotalXP = pupil.totalXP + xpAmount;

      await FirestoreCollections.pupilsCol.doc(pupil.id).update({
        'totalXP': newTotalXP,
        'lastActivityDate': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to add XP: $e');
    }
  }
}
