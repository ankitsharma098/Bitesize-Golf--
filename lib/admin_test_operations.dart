// // Create this file: lib/scripts/create_clubs.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// class ClubCreator {
//   static Future<void> createInitialClubs() async {
//     final clubs = [
//       {
//         'name': 'Local Golf Academy',
//         'location': 'Downtown Sports Complex',
//         'description':
//             'Premier golf training facility with indoor and outdoor ranges',
//         'contactEmail': 'info@localgolfacademy.com',
//         'isActive': true,
//         'totalCoaches': 0,
//         'totalPupils': 0,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       },
//       {
//         'name': 'Sunset Country Club',
//         'location': 'Westside Golf Resort',
//         'description':
//             'Exclusive country club with championship course and pro shop',
//         'contactEmail': 'membership@sunsetcountryclub.com',
//         'isActive': true,
//         'totalCoaches': 0,
//         'totalPupils': 0,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       },
//       {
//         'name': 'Community Golf Center',
//         'location': 'Central Park Sports Area',
//         'description':
//             'Affordable community golf center for all ages and skill levels',
//         'contactEmail': 'welcome@communitygolfcenter.org',
//         'isActive': true,
//         'totalCoaches': 0,
//         'totalPupils': 0,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       },
//     ];
//
//     final batch = FirebaseFirestore.instance.batch();
//
//     for (var clubData in clubs) {
//       final docRef = FirebaseFirestore.instance.collection('clubs').doc();
//       batch.set(docRef, clubData);
//       print('Creating club: ${clubData['name']} with ID: ${docRef.id}');
//     }
//
//     await batch.commit();
//     print('✅ All clubs created successfully!');
//   }
//
//   // Quick function to run from anywhere
//   static Future<void> run() async {
//     try {
//       await createInitialClubs();
//     } catch (e) {
//       print('❌ Error creating clubs: $e');
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bitesize_golf/injection.dart';
import 'package:bitesize_golf/firebase_options.dart';
import 'package:flutter/cupertino.dart';

import 'features/book/model/book_model.dart';
import 'features/challenges/model/challenge_model.dart';
import 'features/games/model/game_model.dart';
import 'features/lesson/model/lesson_model.dart';
import 'features/quizes/model/quiz_model.dart';

/// Run this file directly (right-click → Run) to approve **all pending** join-requests.
/// ⚠️  Use only during development / before real users.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies(); // injectable setup

  final firestore = FirebaseFirestore.instance;

  //--- Approve Pupil → Coach Requests ---
  // final pupilReqs = await firestore
  //     .collection('joinRequests')
  //     .where('requestType', isEqualTo: 'pupil_to_coach')
  //     .where('status', isEqualTo: 'pending')
  //     .get();
  //
  // for (final doc in pupilReqs.docs) {
  //   final data = doc.data();
  //   final batch = firestore.batch();
  //
  //   // 1. Approve request
  //   batch.update(doc.reference, {
  //     'status': 'approved',
  //     'reviewedBy': 'admin_script', // your admin UID later
  //     'reviewedAt': FieldValue.serverTimestamp(),
  //     'reviewNote': 'Auto-approved via admin script',
  //   });
  //
  //   // 2. Update pupil document
  //   final pupilSnap = await firestore
  //       .collection('pupils')
  //       .where('userId', isEqualTo: data['requesterId'])
  //       .limit(1)
  //       .get();
  //
  //   if (pupilSnap.docs.isNotEmpty) {
  //     final pupilDoc = pupilSnap.docs.first.reference;
  //     batch.update(pupilDoc, {
  //       'assignedCoachId': data['targetCoachId'],
  //       'assignedCoachName': data['targetCoachName'],
  //       'assignmentStatus': 'approved',
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     });
  //   }
  //
  //   await batch.commit();
  //   print('✅ Approved pupil→coach request ${doc.id}');
  // }

  //--- Approve Coach → Club Requests ---

  // final coachReqs = await firestore
  //     .collection('joinRequests')
  //     .where('requestType', isEqualTo: 'coach_to_club')
  //     .where('status', isEqualTo: 'pending')
  //     .get();
  //
  // for (final doc in coachReqs.docs) {
  //   final data = doc.data();
  //   final batch = firestore.batch();
  //
  //   // 1. Approve request
  //   batch.update(doc.reference, {
  //     'status': 'approved',
  //     'reviewedBy': 'admin_script',
  //     'reviewedAt': FieldValue.serverTimestamp(),
  //     'reviewNote': 'Auto-approved via admin script',
  //   });
  //
  //   // 2. Update coach document
  //   final coachSnap = await firestore
  //       .collection('coaches')
  //       .where('userId', isEqualTo: data['requesterId'])
  //       .limit(1)
  //       .get();
  //
  //   if (coachSnap.docs.isNotEmpty) {
  //     final coachDoc = coachSnap.docs.first.reference;
  //     batch.update(coachDoc, {
  //       'assignedClubId': data['targetClubId'],
  //       'assignedClubName': data['targetClubName'],
  //       'clubAssignmentStatus': 'approved',
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     });
  //   }
  //
  //   await batch.commit();
  //   print('✅ Approved coach→club request ${doc.id}');
  // }

  // print('🎉 All pending requests approved!');

  await createRedLevelLesson(firestore);
}

/* ------------------------------------------------------------------ */
/* 2.  Quiz payload (exact JSON you supplied)                         */
/* ------------------------------------------------------------------ */
final _redLevelQuizJson = <String, dynamic>{
  "quizId": "",
  "title": "Red Level Quiz",
  "description":
      "Golf etiquette and rules quiz for beginner level. Test your knowledge of basic golf rules, course etiquette, equipment regulations, and proper behavior on the golf course.",
  "levelNumber": 1,
  "timeLimit": 600,
  "passingScore": 50,
  "allowRetakes": true,
  "maxAttempts": 5,
  "questions": [
    {
      "questionId": "q1",
      "type": "multiple_choice",
      "question": "When someone is playing their shot, what should you do?",
      "options": [
        "Stand still and be quiet",
        "Clap",
        "Play your shot at the same time",
      ],
      "correctAnswer": "Stand still and be quiet",
      "explanation":
          "Golf etiquette requires players to remain quiet and still while others are taking their shots to avoid distraction.",
      "points": 10,
    },
    {
      "questionId": "q2",
      "type": "multiple_choice",
      "question": "Which of these is not accepted on most private golf clubs?",
      "options": ["Baseball caps", "Trainers", "Denim jeans"],
      "correctAnswer": "Denim jeans",
      "explanation":
          "Most private golf clubs have strict dress codes that typically prohibit denim jeans. Proper golf attire is required.",
      "points": 10,
    },
    {
      "questionId": "q3",
      "type": "multiple_choice",
      "question":
          "What should you shout if your ball is flying towards someone?",
      "options": ["Watch out!", "Fore", "Sorry"],
      "correctAnswer": "Fore",
      "explanation":
          "'Fore' is the traditional golf warning shout to alert other players of an incoming ball that might hit them.",
      "points": 10,
    },
    {
      "questionId": "q4",
      "type": "multiple_choice",
      "question":
          "What happens if you accidentally move your ball on the fairway?",
      "options": [
        "You must put the ball back to where it was and play on, 1 stroke penalty",
        "You must put the ball back to where it was and play on",
        "You get 3 chances and then it counts as a stroke",
      ],
      "correctAnswer":
          "You must put the ball back to where it was and play on, 1 stroke penalty",
      "explanation":
          "Under golf rules, accidentally moving your ball results in a one-stroke penalty and the ball must be replaced to its original position.",
      "points": 10,
    },
    {
      "questionId": "q5",
      "type": "multiple_choice",
      "question": "What happens if you take a swing and miss the ball?",
      "options": [
        "Nothing, just have another go",
        "It counts as a stroke",
        "You get 3 chances or it then counts as a stroke",
      ],
      "correctAnswer": "It counts as a stroke",
      "explanation":
          "Any intentional swing at the ball counts as a stroke, even if you miss the ball completely.",
      "points": 10,
    },
    {
      "questionId": "q6",
      "type": "multiple_choice",
      "question": "How many clubs are you allowed in your golf bag?",
      "options": ["Up to 15", "Up to 18", "Up to 14"],
      "correctAnswer": "Up to 14",
      "explanation":
          "Golf rules allow a maximum of 14 clubs in your bag during a round.",
      "points": 10,
    },
    {
      "questionId": "q7",
      "type": "multiple_choice",
      "question": "Which club will usually send the ball the farthest?",
      "options": ["7 iron", "9 iron", "5 iron"],
      "correctAnswer": "5 iron",
      "explanation":
          "Lower numbered irons have less loft and typically hit the ball farther than higher numbered irons.",
      "points": 10,
    },
    {
      "questionId": "q8",
      "type": "multiple_choice",
      "question": "Which of these is known as the 'Driver'?",
      "options": ["1 wood", "3 wood", "Sand wedge"],
      "correctAnswer": "1 wood",
      "explanation":
          "The driver is also known as the 1 wood and is typically used for tee shots on long holes.",
      "points": 10,
    },
    {
      "questionId": "q9",
      "type": "multiple_choice",
      "question": "Which shot will go the highest?",
      "options": ["A putt", "A pitch", "A chip"],
      "correctAnswer": "A pitch",
      "explanation":
          "A pitch shot is designed to go high in the air and land softly, making it go higher than putts or chip shots.",
      "points": 10,
    },
    {
      "questionId": "q10",
      "type": "multiple_choice",
      "question":
          "What should you do if you are holding players up on the course?",
      "options": [
        "Ignore them",
        "Speed up by missing out a few holes",
        "Invite them to play through",
      ],
      "correctAnswer": "Invite them to play through",
      "explanation":
          "Golf etiquette requires slower groups to allow faster groups to play through when possible to maintain pace of play.",
      "points": 10,
    },
  ],
  "totalQuestions": 10,
  "totalPoints": 100,
  "estimatedTime": 480,
  "accessTier": "free",
  "isActive": true,
  "sortOrder": 1,
  "createdAt": "2024-01-15T10:00:00Z",
  "updatedAt": "2024-01-15T10:00:00Z",
  "createdBy": "admin",
};

/* ------------------------------------------------------------------ */
/* 3.  Main                                                           */
/* ------------------------------------------------------------------ */
Future<void> createRedLevelQuiz(FirebaseFirestore firestore) async {
  const levelToInsert = 1;

  // 3.1  Check uniqueness
  final existing = await firestore
      .collection('quizzes')
      .where('levelNumber', isEqualTo: levelToInsert)
      .limit(1)
      .get();

  if (existing.docs.isNotEmpty) {
    print(
      '❌  A quiz for level-$levelToInsert already exists (${existing.docs.first.id}) – aborting.',
    );
    return;
  }

  // 3.2  Build model (timestamps will be overwritten by serverTimestamp below)
  final model = QuizModel.fromJson(_redLevelQuizJson);

  // 3.3  Write document
  final docRef = firestore.collection('quizzes').doc(); // auto-id
  await docRef.set(
    model
        .copyWith(
          createdAt: DateTime.now(), // local convenience
          updatedAt: DateTime.now(),
        )
        .toJson()
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp(),
  );

  print('✅  Red-Level quiz created with id: ${docRef.id}');
}

Map<String, dynamic> redLevelBook = {
  "id": "",
  "title": "Red Level Book",
  "description":
      "Learn key golf skills step by step — with clear tips, fun examples, and simple rules. Swipe through the pages and get ready for the quiz at the end!",
  "estimatedReadTime": 15,
  "levelNumber": 1,
  "pdfUrl":
      "https://drive.google.com/file/d/1bYKniPjKgKeDHJmI1_TgI7rp2xr-NjfM/view?usp=sharing", // You'll add this yourself
  "accessTier": "free",
  "isActive": true,
  "publishedAt": null, // You can set this when publishing
  "sortOrder": 1,
  "createdAt": null, // System will set this
  "updatedAt": null, // System will set this
  "createdBy": "admin", // You'll need to specify the admin/coach
};
Future<void> createRedLevelBook(FirebaseFirestore firestore) async {
  const levelToInsert = 1;

  // 3.1  Check uniqueness
  final existing = await firestore
      .collection('books')
      .where('levelNumber', isEqualTo: levelToInsert)
      .limit(1)
      .get();

  if (existing.docs.isNotEmpty) {
    print(
      '❌  A book for level-$levelToInsert already exists (${existing.docs.first.id}) – aborting.',
    );
    return;
  }

  // 3.2  Build model (timestamps will be overwritten by serverTimestamp below)
  final model = BookModel.fromJson(redLevelBook);

  // 3.3  Write document
  final docRef = firestore.collection('books').doc(); // auto-id
  await docRef.set(
    model
        .copyWith(
          createdAt: DateTime.now(), // local convenience
          updatedAt: DateTime.now(),
          id: docRef.id,
        )
        .toJson()
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp(),
  );

  print('✅  Red-Level books created with id: ${docRef.id}');
}

Map<String, dynamic> redLevelLesson = {
  "id": "",
  "title": "Red Level Lesson",
  "description":
      "Learn key golf skills step by step — with clear tips, fun examples, and simple rules. Swipe through the pages and get ready for the quiz at the end!",
  "estimatedReadTime": 15,
  "levelNumber": 1,
  "pdfUrl":
      "https://drive.google.com/file/d/1-65VIrdQKji4gs07WoJ12OHB2P6Clpx6/view?usp=sharing", // You'll add this yourself
  "accessTier": "free",
  "isActive": true,
  "publishedAt": null, // You can set this when publishing
  "sortOrder": 1,
  "createdAt": null, // System will set this
  "updatedAt": null, // System will set this
  "createdBy": "admin", // You'll need to specify the admin/coach
};
Future<void> createRedLevelLesson(FirebaseFirestore firestore) async {
  const levelToInsert = 1;

  // 3.1  Check uniqueness
  final existing = await firestore
      .collection('lessons')
      .where('levelNumber', isEqualTo: levelToInsert)
      .limit(1)
      .get();

  if (existing.docs.isNotEmpty) {
    print(
      '❌  A Lesson for level-$levelToInsert already exists (${existing.docs.first.id}) – aborting.',
    );
    return;
  }

  // 3.2  Build model (timestamps will be overwritten by serverTimestamp below)
  final model = LessonModel.fromJson(redLevelLesson);

  // 3.3  Write document
  final docRef = firestore.collection('lessons').doc(); // auto-id
  await docRef.set(
    model
        .copyWith(
          createdAt: DateTime.now(), // local convenience
          updatedAt: DateTime.now(),
          id: docRef.id,
        )
        .toJson()
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp(),
  );

  print('✅  Red-Level books created with id: ${docRef.id}');
}

Map<String, dynamic> redLevelChallenge = {
  "id": "",
  "title": "Red Level Challenges",
  "description":
      "Master the basic golf shots and putting techniques. This challenge focuses on consistency and form rather than distance.",
  "proTip":
      "Keep practicing and aim for 1 great shot in each challenge! Ask your coach for help if needed — you're doing great!",
  "levelNumber": 1,
  "tasks": [
    {
      "id": "task_1",
      "title": "Iron shot 25m",
      "maxScore": 5,
      "passingScore": 1,
    },
    {
      "id": "task_2",
      "title": "Wood shot 50m",
      "maxScore": 5,
      "passingScore": 1,
    },
    {
      "id": "task_3",
      "title": "Chip into 3m circle",
      "maxScore": 5,
      "passingScore": 1,
    },
    {
      "id": "task_4",
      "title": "Out of bunker",
      "maxScore": 5,
      "passingScore": 1,
    },
    {"id": "task_5", "title": "Putt from 2m", "maxScore": 5, "passingScore": 1},
  ],
  "totalTasks": 6,
  "minTasksToPass": 4,
  "quizPassingScore": 5,
  "estimatedTime": 45,
  "isActive": true,
  "sortOrder": 1,
};

Future<void> createRedLevelChallenges(FirebaseFirestore firestore) async {
  const levelToInsert = 1;

  // 3.1  Check uniqueness
  final existing = await firestore
      .collection('challenges')
      .where('levelNumber', isEqualTo: levelToInsert)
      .limit(1)
      .get();

  if (existing.docs.isNotEmpty) {
    print(
      '❌  A book for level-$levelToInsert already exists (${existing.docs.first.id}) – aborting.',
    );
    return;
  }

  // 3.2  Build model (timestamps will be overwritten by serverTimestamp below)
  final model = ChallengeModel.fromJson(redLevelChallenge);

  // 3.3  Write document
  final docRef = firestore.collection('challenges').doc(); // auto-id
  await docRef.set(
    model
        .copyWith(
          id: docRef.id,
          createdAt: DateTime.now(), // local convenience
          updatedAt: DateTime.now(),
        )
        .toJson()
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp(),
  );

  print('✅  Red-Level books created with id: ${docRef.id}');
}

// Red Level Games
final Map<String, dynamic> chippingGameRed = {
  'id': '',
  'title': 'Chipping Game',
  'description':
      'Watch the activity and have fun playing and practicing these skills and drills. They are great fun, they can be challenging, but they will improve your game.',
  'levelNumber': 1,
  'videoUrl': 'https://example.com/videos/red_chipping_game.mp4',
  'thumbnailUrl': 'https://example.com/thumbnails/red_chipping.jpg',
  'estimatedTime': 5, // 5 minutes
  'accessTier': 'free',
  'isActive': true,
  'sortOrder': 1,
  'createdAt': DateTime.now().toIso8601String(),
  'updatedAt': DateTime.now().toIso8601String(),
  'createdBy': 'admin',
  'category': 'chipping',
  'tipText':
      'Focus on aim, posture, and keeping your eye on the ball. Good luck!',
  'videoDurationSeconds': 300, // 5 minutes
};

final Map<String, dynamic> ironGameRed = {
  'id': '',
  'title': 'Iron Game',
  'description':
      'Watch the activity and have fun playing and practicing these skills and drills. They are great fun, they can be challenging, but they will improve your game.',
  'levelNumber': 1,
  'videoUrl': 'https://example.com/videos/red_iron_game.mp4',
  'thumbnailUrl': 'https://example.com/thumbnails/red_iron.jpg',
  'estimatedTime': 6, // 6 minutes
  'accessTier': 'free',
  'isActive': true,
  'sortOrder': 2,
  'createdAt': DateTime.now().toIso8601String(),
  'updatedAt': DateTime.now().toIso8601String(),
  'createdBy': 'admin',
  'category': 'iron',
  'tipText':
      'Focus on aim, posture, and keeping your eye on the ball. Good luck!',
  'videoDurationSeconds': 360, // 6 minutes
};

final Map<String, dynamic> puttingGameRed = {
  'id': 'game_red_putting_001',
  'title': 'Putting Game',
  'description':
      'Watch the activity and have fun playing and practicing these skills and drills. They are great fun, they can be challenging, but they will improve your game.',
  'levelNumber': 1,
  'videoUrl': 'https://example.com/videos/red_putting_game.mp4',
  'thumbnailUrl': 'https://example.com/thumbnails/red_putting.jpg',
  'estimatedTime': 4, // 4 minutes
  'accessTier': 'free',
  'isActive': true,
  'sortOrder': 3,
  'createdAt': DateTime.now().toIso8601String(),
  'updatedAt': DateTime.now().toIso8601String(),
  'createdBy': 'admin',
  'category': 'putting',
  'tipText':
      'Focus on aim, posture, and keeping your eye on the ball. Good luck!',
  'videoDurationSeconds': 240, // 4 minutes
};

final Map<String, dynamic> woodGameRed = {
  'id': '',
  'title': 'Wood Game',
  'description':
      'Watch the activity and have fun playing and practicing these skills and drills. They are great fun, they can be challenging, but they will improve your game.',
  'levelNumber': 1,
  'videoUrl': 'https://example.com/videos/red_wood_game.mp4',
  'thumbnailUrl': 'https://example.com/thumbnails/red_wood.jpg',
  'estimatedTime': 7, // 7 minutes
  'accessTier': 'free',
  'isActive': true,
  'sortOrder': 4,
  'createdAt': DateTime.now().toIso8601String(),
  'updatedAt': DateTime.now().toIso8601String(),
  'createdBy': 'admin',
  'category': 'wood',
  'tipText':
      'Focus on aim, posture, and keeping your eye on the ball. Good luck!',
  'videoDurationSeconds': 420, // 7 minutes
};

Future<void> createGamesOfRedLevel(FirebaseFirestore firestore) async {
  const levelToInsert = 1;

  // Define all red level games
  final List<Map<String, dynamic>> redLevelGames = [
    chippingGameRed,
    ironGameRed,
    puttingGameRed,
    woodGameRed,
  ];

  print('🚀 Starting to create Red Level games...');

  for (final gameData in redLevelGames) {
    try {
      // 1. Check if game already exists using levelNumber + category combination
      final existing = await firestore
          .collection('games')
          .where('levelNumber', isEqualTo: levelToInsert)
          .where('category', isEqualTo: gameData['category'])
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        print(
          '⚠️  Game already exists: Level $levelToInsert - ${gameData['category']} (${existing.docs.first.id}) – skipping.',
        );
        continue;
      }

      // 2. Create new document with auto-generated ID
      final docRef = firestore.collection('games').doc(); // auto-id

      // 3. Prepare data with proper ID and server timestamps
      final gameToUpload = GameModel.fromJson(gameData).copyWith(
        id: docRef.id,
        createdAt:
            DateTime.now(), // Will be overridden by serverTimestamp below
        updatedAt:
            DateTime.now(), // Will be overridden by serverTimestamp below
      );

      // 4. Upload to Firestore
      await docRef.set(
        gameToUpload.toJson()
          ..['createdAt'] = FieldValue.serverTimestamp()
          ..['updatedAt'] = FieldValue.serverTimestamp(),
      );

      print(
        '✅ Created game: Level $levelToInsert - ${gameData['category']} (${docRef.id})',
      );
    } catch (e) {
      print('❌ Failed to create game: ${gameData['category']} - Error: $e');
    }
  }

  print('🎯 Red Level games creation completed!');
}
