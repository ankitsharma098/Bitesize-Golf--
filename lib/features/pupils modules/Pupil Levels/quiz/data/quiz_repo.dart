import 'package:bitesize_golf/core/utils/user_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../Models/quiz attempt model/quiz_attempt_model.dart';
import '../../../../../Models/quiz model/quiz_model.dart';
import '../../../../../core/constants/firebase_collections_names.dart';
import '../../../../../core/utils/pupil_progress_services.dart';

class QuizRepository {
  final UserUtil _userUtil = UserUtil();
  final PupilProgressService _pupilProgressService = PupilProgressService();

  /// Get all quizzes for a specific level
  Future<List<QuizModel>> getQuizzesByLevel(int levelNumber) async {
    try {
      final querySnapshot = await FirestoreCollections.quizzesCol
          .where('levelNumber', isEqualTo: levelNumber)
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return QuizModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch quizzes by level: $e');
    }
  }

  /// Get a single quiz by ID
  Future<QuizModel?> getQuizById(String quizId) async {
    try {
      final doc = await FirestoreCollections.quizzesCol.doc(quizId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return QuizModel.fromFirestore(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch quiz: $e');
    }
  }

  /// Get the first quiz for a specific level
  Future<QuizModel?> getFirstQuizByLevel(int levelNumber) async {
    try {
      final quizzes = await getQuizzesByLevel(levelNumber);
      return quizzes.isNotEmpty ? quizzes.first : null;
    } catch (e) {
      throw Exception('Failed to fetch first quiz by level: $e');
    }
  }

  /// Start a new quiz attempt
  Future<QuizAttemptModel> startQuizAttempt(
    String quizId,
    int levelNumber,
    int totalQuestions,
    int totalPoints,
  ) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('User not authenticated as pupil');

      final now = DateTime.now();
      final attemptId = '${pupil.id}_${quizId}_${now.millisecondsSinceEpoch}';

      final attempt = QuizAttemptModel(
        id: attemptId,
        pupilId: pupil.id,
        quizId: quizId,
        levelNumber: levelNumber,
        startedAt: now,
        status: 'in_progress',
        totalQuestions: totalQuestions,
        totalPoints: totalPoints,
        createdAt: now,
        updatedAt: now,
      );

      // Save to Firestore
      await FirestoreCollections.quizAttemptsCol
          .doc(attemptId)
          .set(attempt.toFirestore());

      return attempt;
    } catch (e) {
      throw Exception('Failed to start quiz attempt: $e');
    }
  }

  /// Update quiz attempt progress (for auto-saving during quiz)
  Future<QuizAttemptModel> updateQuizAttemptProgress(
    String attemptId,
    List<QuestionResponse> responses,
    int scoreObtained,
    int timeTaken,
  ) async {
    try {
      // Get existing attempt
      final doc = await FirestoreCollections.quizAttemptsCol
          .doc(attemptId)
          .get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Quiz attempt not found');
      }

      final existingAttempt = QuizAttemptModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
      );

      // Update attempt with new progress
      final updatedAttempt = existingAttempt.copyWith(
        responses: responses,
        scoreObtained: scoreObtained,
        timeTaken: timeTaken,
        updatedAt: DateTime.now(),
      );

      // Save updated attempt
      await FirestoreCollections.quizAttemptsCol.doc(attemptId).update({
        'responses': updatedAttempt.responses
            .map((r) => r.toFirestore())
            .toList(),
        'scoreObtained': scoreObtained,
        'timeTaken': timeTaken,
        'updatedAt': updatedAttempt.updatedAt.toIso8601String(),
      });

      return updatedAttempt;
    } catch (e) {
      throw Exception('Failed to update quiz attempt progress: $e');
    }
  }

  /// Complete a quiz attempt
  Future<QuizAttemptModel> completeQuizAttempt(
    String attemptId,
    String quizId,
    int levelNumber,
    List<QuestionResponse> responses,
    int scoreObtained,
    int timeTaken,
    bool passed,
  ) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('User not authenticated as pupil');

      final now = DateTime.now();

      // Get existing attempt
      final doc = await FirestoreCollections.quizAttemptsCol
          .doc(attemptId)
          .get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Quiz attempt not found');
      }

      final existingAttempt = QuizAttemptModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
      );

      // Update attempt with completion data
      final completedAttempt = existingAttempt.copyWith(
        completedAt: now,
        status: 'completed',
        scoreObtained: scoreObtained,
        passed: passed,
        timeTaken: timeTaken,
        responses: responses,
        updatedAt: now,
      );

      // Save updated attempt
      await FirestoreCollections.quizAttemptsCol
          .doc(attemptId)
          .set(completedAttempt.toFirestore());

      // If quiz was passed, update pupil progress
      if (passed) {
        // Calculate percentage score for the progress service
        final percentageScore =
            (scoreObtained / completedAttempt.totalPoints) * 100;

        await _pupilProgressService.updateQuizCompletion(
          levelNumber,
          percentageScore,
        );
        await _pupilProgressService.addXP(100); // Award XP for quiz completion

        // Check if level is completed
        final isLevelCompleted = await _pupilProgressService
            .checkLevelCompletion(levelNumber);
        if (isLevelCompleted) {
          await _pupilProgressService.completeLevelProgress(levelNumber);
          await _pupilProgressService.addXP(
            150,
          ); // Bonus XP for level completion
        }
      }

      return completedAttempt;
    } catch (e) {
      throw Exception('Failed to complete quiz attempt: $e');
    }
  }

  /// Get quiz attempts for a specific quiz
  Future<List<QuizAttemptModel>> getQuizAttempts(String quizId) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) return [];

      final querySnapshot = await FirestoreCollections.quizAttemptsCol
          .where('pupilId', isEqualTo: pupil.id)
          .where('quizId', isEqualTo: quizId)
          .orderBy('startedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return QuizAttemptModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch quiz attempts: $e');
    }
  }

  /// Get quiz attempts for a specific level
  Future<List<QuizAttemptModel>> getQuizAttemptsByLevel(int levelNumber) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) return [];

      final querySnapshot = await FirestoreCollections.quizAttemptsCol
          .where('pupilId', isEqualTo: pupil.id)
          .where('levelNumber', isEqualTo: levelNumber)
          .orderBy('startedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return QuizAttemptModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch quiz attempts by level: $e');
    }
  }
  // Add these methods to your QuizRepository class

  /// Resume an in-progress quiz
  Future<QuizAttemptModel?> resumeQuizAttempt(String attemptId) async {
    try {
      final doc = await FirestoreCollections.quizAttemptsCol
          .doc(attemptId)
          .get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final attempt = QuizAttemptModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
      );

      // Only return if it's actually in progress
      if (attempt.status == 'in_progress') {
        return attempt;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to resume quiz attempt: $e');
    }
  }

  /// Check if a specific quiz has an active attempt
  Future<bool> hasActiveAttempt(String quizId) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) return false;

      final querySnapshot = await FirestoreCollections.quizAttemptsCol
          .where('pupilId', isEqualTo: pupil.id)
          .where('quizId', isEqualTo: quizId)
          .where('status', isEqualTo: 'in_progress')
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Failed to check active attempts: $e');
      return false;
    }
  }

  /// Get best quiz attempt for a quiz (highest score)
  Future<QuizAttemptModel?> getBestQuizAttempt(String quizId) async {
    try {
      final attempts = await getQuizAttempts(quizId);
      if (attempts.isEmpty) return null;

      // Filter completed attempts and find the one with highest score
      final completedAttempts = attempts
          .where((attempt) => attempt.status == 'completed')
          .toList();

      if (completedAttempts.isEmpty) return null;

      completedAttempts.sort(
        (a, b) => b.scoreObtained.compareTo(a.scoreObtained),
      );
      return completedAttempts.first;
    } catch (e) {
      throw Exception('Failed to get best quiz attempt: $e');
    }
  }

  /// Check if user has passed any quiz in a level
  Future<bool> hasPassedLevelQuiz(int levelNumber) async {
    try {
      final attempts = await getQuizAttemptsByLevel(levelNumber);
      return attempts.any(
        (attempt) => attempt.status == 'completed' && attempt.passed,
      );
    } catch (e) {
      throw Exception('Failed to check level quiz completion: $e');
    }
  }

  /// Get quiz completion statistics for a level
  Future<Map<String, dynamic>> getLevelQuizStats(int levelNumber) async {
    try {
      final quizzes = await getQuizzesByLevel(levelNumber);
      final attempts = await getQuizAttemptsByLevel(levelNumber);

      final completedAttempts = attempts
          .where((attempt) => attempt.status == 'completed')
          .toList();

      final passedAttempts = completedAttempts
          .where((attempt) => attempt.passed)
          .toList();

      return {
        'totalQuizzes': quizzes.length,
        'totalAttempts': attempts.length,
        'completedAttempts': completedAttempts.length,
        'passedAttempts': passedAttempts.length,
        'averageScore': completedAttempts.isEmpty
            ? 0.0
            : completedAttempts
                      .map((a) => a.scoreObtained)
                      .reduce((a, b) => a + b) /
                  completedAttempts.length,
        'bestScore': completedAttempts.isEmpty
            ? 0
            : completedAttempts
                  .map((a) => a.scoreObtained)
                  .reduce((a, b) => a > b ? a : b),
        'hasPassedAnyQuiz': passedAttempts.isNotEmpty,
      };
    } catch (e) {
      throw Exception('Failed to get level quiz stats: $e');
    }
  }

  /// Abandon a quiz attempt (when user exits without completing)
  Future<void> abandonQuizAttempt(String attemptId) async {
    try {
      await FirestoreCollections.quizAttemptsCol.doc(attemptId).update({
        'status': 'abandoned',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to abandon quiz attempt: $e');
    }
  }

  /// Mark quiz attempt as expired (when time runs out)
  Future<QuizAttemptModel> expireQuizAttempt(
    String attemptId,
    List<QuestionResponse> responses,
    int scoreObtained,
    int timeTaken,
  ) async {
    try {
      final now = DateTime.now();

      // Get existing attempt
      final doc = await FirestoreCollections.quizAttemptsCol
          .doc(attemptId)
          .get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Quiz attempt not found');
      }

      final existingAttempt = QuizAttemptModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
      );

      // Update attempt as expired
      final expiredAttempt = existingAttempt.copyWith(
        completedAt: now,
        status: 'expired',
        scoreObtained: scoreObtained,
        passed: false, // Expired attempts are never passed
        timeTaken: timeTaken,
        responses: responses,
        updatedAt: now,
      );

      // Save updated attempt
      await FirestoreCollections.quizAttemptsCol
          .doc(attemptId)
          .set(expiredAttempt.toFirestore());

      return expiredAttempt;
    } catch (e) {
      throw Exception('Failed to expire quiz attempt: $e');
    }
  }

  /// Get quiz progress summary for dashboard/level overview
  Future<Map<String, dynamic>> getQuizProgressSummary(int levelNumber) async {
    try {
      final stats = await getLevelQuizStats(levelNumber);
      final quizzes = await getQuizzesByLevel(levelNumber);

      return {
        'totalQuizzes': stats['totalQuizzes'],
        'completedQuizzes':
            stats['passedAttempts'], // Count unique passed quizzes
        'bestScore': stats['bestScore'],
        'averageScore': stats['averageScore'],
        'hasQuizzes': quizzes.isNotEmpty,
        'canTakeQuiz': quizzes.isNotEmpty,
        'completionPercentage': quizzes.isEmpty
            ? 0.0
            : (stats['passedAttempts'] as int) / quizzes.length * 100,
      };
    } catch (e) {
      throw Exception('Failed to get quiz progress summary: $e');
    }
  }

  // Add these methods to your QuizRepository class
  Future<void> saveQuizProgress(
    String attemptId,
    List<QuestionResponse> responses,
    int scoreObtained,
  ) async {
    try {
      final now = DateTime.now();

      await FirestoreCollections.quizAttemptsCol.doc(attemptId).update({
        'responses': responses.map((r) => r.toFirestore()).toList(),
        'scoreObtained': scoreObtained,
        'updatedAt': now
            .toIso8601String(), // Use ISO string instead of Timestamp
      });
    } catch (e) {
      // Log error but don't throw - we don't want to break quiz flow
      print('Failed to save quiz progress: $e');
    }
  }

  /// Get latest quiz attempt for a quiz (most recent by startedAt timestamp)
  Future<QuizAttemptModel?> getLatestQuizAttempt(String quizId) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) return null;

      final querySnapshot = await FirestoreCollections.quizAttemptsCol
          .where('pupilId', isEqualTo: pupil.id)
          .where('quizId', isEqualTo: quizId)
          .orderBy('startedAt', descending: true) // Most recent first
          .limit(1) // Only get the latest one
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      return QuizAttemptModel.fromFirestore(data);
    } catch (e) {
      throw Exception('Failed to get latest quiz attempt: $e');
    }
  }

  /// Check if user can retake a quiz based on attempt history and quiz settings
  Future<bool> canRetakeQuiz(String quizId) async {
    try {
      final quiz = await getQuizById(quizId);
      if (quiz == null || !quiz.allowRetakes) return false;

      if (quiz.maxAttempts != null) {
        final pupil = await _userUtil.getCurrentPupil();
        if (pupil == null) return false;

        // Count only COMPLETED attempts (not in-progress, abandoned, or expired)
        final querySnapshot = await FirestoreCollections.quizAttemptsCol
            .where('pupilId', isEqualTo: pupil.id)
            .where('quizId', isEqualTo: quizId)
            .where('status', isEqualTo: 'completed')
            .get();

        return querySnapshot.docs.length < quiz.maxAttempts!;
      }

      return true; // No max attempts limit
    } catch (e) {
      throw Exception('Failed to check retake eligibility: $e');
    }
  }

  /// Get active (in-progress) quiz attempts for a user
  Future<List<QuizAttemptModel>> getActiveQuizAttempts() async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) return [];

      final querySnapshot = await FirestoreCollections.quizAttemptsCol
          .where('pupilId', isEqualTo: pupil.id)
          .where('status', isEqualTo: 'in_progress')
          .orderBy('startedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return QuizAttemptModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch active quiz attempts: $e');
    }
  }
}
