import 'package:cloud_firestore/cloud_firestore.dart';

/// Central place for every top-level collection name and helper getters.
abstract class FirestoreCollections {
  static const String users = 'users';
  static const String pupils = 'pupils';
  static const String coaches = 'coaches';
  static const String pupilToCoach = 'pupil_to_coach_requests';
  static const String coachToClub = 'coach_to_club_requests';
  static const String coachVerify = 'coach_verification_requests';
  static const String levels = 'levels';
  static const String sessions = 'sessions';
  static const String schedules = 'schedules';
  static const String clubs = 'clubs';
  static const String subscriptionLogs = 'subscriptionLogs';
  static const String books = 'books';
  static const String bookProgress = 'book_progress';
  static const String quizzes = 'quizzes';
  static const String quizAttempts = 'quizAttempts';

  /* ---------- typed CollectionReference helpers ---------- */
  static CollectionReference<Map<String, dynamic>> get usersCol =>
      FirebaseFirestore.instance.collection(users);

  static CollectionReference<Map<String, dynamic>> get pupilsCol =>
      FirebaseFirestore.instance.collection(pupils);

  static CollectionReference<Map<String, dynamic>> get coachesCol =>
      FirebaseFirestore.instance.collection(coaches);

  static CollectionReference<Map<String, dynamic>> get pupilCoachReqCol =>
      FirebaseFirestore.instance.collection(pupilToCoach);

  static CollectionReference<Map<String, dynamic>> get coachClubReqCol =>
      FirebaseFirestore.instance.collection(coachToClub);

  static CollectionReference<Map<String, dynamic>> get coachVerifReqCol =>
      FirebaseFirestore.instance.collection(coachVerify);

  static CollectionReference<Map<String, dynamic>> get levelsCol =>
      FirebaseFirestore.instance.collection(levels);

  static CollectionReference<Map<String, dynamic>> get sessionsCol =>
      FirebaseFirestore.instance.collection(sessions);

  static CollectionReference<Map<String, dynamic>> get clubsCol =>
      FirebaseFirestore.instance.collection(clubs);

  static CollectionReference<Map<String, dynamic>> get schedulesCol =>
      FirebaseFirestore.instance.collection(schedules);

  static CollectionReference<Map<String, dynamic>> get subscriptionLogsCol =>
      FirebaseFirestore.instance.collection(subscriptionLogs);

  static CollectionReference get booksCol =>
      FirebaseFirestore.instance.collection(books);
  static CollectionReference get bookProgressCol =>
      FirebaseFirestore.instance.collection(bookProgress);

  static CollectionReference get quizzesCol =>
      FirebaseFirestore.instance.collection(quizzes);
  static CollectionReference get quizAttemptsCol =>
      FirebaseFirestore.instance.collection(quizAttempts);
}
