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

  final coachReqs = await firestore
      .collection('joinRequests')
      .where('requestType', isEqualTo: 'coach_to_club')
      .where('status', isEqualTo: 'pending')
      .get();

  for (final doc in coachReqs.docs) {
    final data = doc.data();
    final batch = firestore.batch();

    // 1. Approve request
    batch.update(doc.reference, {
      'status': 'approved',
      'reviewedBy': 'admin_script',
      'reviewedAt': FieldValue.serverTimestamp(),
      'reviewNote': 'Auto-approved via admin script',
    });

    // 2. Update coach document
    final coachSnap = await firestore
        .collection('coaches')
        .where('userId', isEqualTo: data['requesterId'])
        .limit(1)
        .get();

    if (coachSnap.docs.isNotEmpty) {
      final coachDoc = coachSnap.docs.first.reference;
      batch.update(coachDoc, {
        'assignedClubId': data['targetClubId'],
        'assignedClubName': data['targetClubName'],
        'clubAssignmentStatus': 'approved',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    print('✅ Approved coach→club request ${doc.id}');
  }

  print('🎉 All pending requests approved!');
}
