// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:injectable/injectable.dart';
//
// class JoinRequestRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Collections
//   CollectionReference get _joinRequests =>
//       _firestore.collection('joinRequests');
//
//   /// Create a pupil to coach join request
//   /// Create a pupil to coach join request
//   Future<void> createPupilToCoachRequest({
//     required String pupilUserId,
//     required String pupilName,
//     required String coachId,
//     required String coachName,
//     String? clubId, // ADD THIS
//     String? clubName, // ADD THIS
//     String? message,
//   }) async {
//     try {
//       final requestId = _joinRequests.doc().id;
//       final request = JoinRequestModel.pupilToCoach(
//         id: requestId,
//         pupilUserId: pupilUserId,
//         pupilName: pupilName,
//         coachId: coachId,
//         coachName: coachName,
//         clubId: clubId, // ADD THIS
//         clubName: clubName, // ADD THIS
//         message: message,
//       );
//
//       await _joinRequests.doc(requestId).set(request.toJson());
//     } catch (e) {
//       throw Exception('Failed to create pupil to coach request: $e');
//     }
//   }
//
//   /// Create a coach to club join request
//   Future<void> createCoachToClubRequest({
//     required String coachUserId,
//     required String coachName,
//     required String clubId,
//     required String clubName,
//     String? message,
//   }) async {
//     try {
//       final requestId = _joinRequests.doc().id;
//       final request = JoinRequestModel.coachToClub(
//         id: requestId,
//         coachUserId: coachUserId,
//         coachName: coachName,
//         clubId: clubId,
//         clubName: clubName,
//         message: message,
//       );
//
//       await _joinRequests.doc(requestId).set(request.toJson());
//     } catch (e) {
//       throw Exception('Failed to create coach to club request: $e');
//     }
//   }
//
//   /// Create a coach verification request (for admin approval)
//   Future<void> createCoachVerificationRequest({
//     required String coachUserId,
//     required String coachName,
//     String? message,
//   }) async {
//     try {
//       final requestId = _joinRequests.doc().id;
//       final request = JoinRequestModel.coachVerification(
//         id: requestId,
//         coachUserId: coachUserId,
//         coachName: coachName,
//         message: message,
//       );
//
//       await _joinRequests.doc(requestId).set(request.toJson());
//     } catch (e) {
//       throw Exception('Failed to create coach verification request: $e');
//     }
//   }
//
//   /// Create multiple join requests in a batch
//   // Add this debugging in your createJoinRequestsBatch method:
//
//   /// Create multiple join requests in a batch
//   Future<void> createJoinRequestsBatch({
//     required String userId,
//     required String userName,
//     required String userRole,
//     String? targetCoachId,
//     String? targetCoachName,
//     String? targetClubId,
//     String? targetClubName,
//     bool createCoachRequest = false,
//     bool createClubRequest = false,
//     bool createVerificationRequest = false,
//     String? message,
//   }) async {
//     try {
//       // DEBUG: Print all parameters
//       print('🔍 createJoinRequestsBatch called with:');
//       print('   userId: $userId');
//       print('   userName: $userName');
//       print('   userRole: $userRole');
//       print('   targetCoachId: $targetCoachId');
//       print('   targetCoachName: $targetCoachName');
//       print('   targetClubId: $targetClubId');
//       print('   targetClubName: $targetClubName');
//       print('   createCoachRequest: $createCoachRequest');
//
//       final batch = _firestore.batch();
//
//       // Create pupil → coach request
//       if (createCoachRequest &&
//           targetCoachId != null &&
//           targetCoachName != null) {
//         print('🎯 Creating pupil-to-coach request with:');
//         print('   Coach: $targetCoachName ($targetCoachId)');
//         print('   Club: $targetClubName ($targetClubId)');
//
//         final requestId = _joinRequests.doc().id;
//         final request = JoinRequestModel.pupilToCoach(
//           id: requestId,
//           pupilUserId: userId,
//           pupilName: userName,
//           coachId: targetCoachId,
//           coachName: targetCoachName,
//           clubId: targetClubId, // This should now work
//           clubName: targetClubName, // This should now work
//           message: message,
//         );
//
//         // DEBUG: Print the request before saving
//         final requestJson = request.toJson();
//         print('📄 Request JSON before saving:');
//         print('   targetCoachId: ${requestJson['targetCoachId']}');
//         print('   targetCoachName: ${requestJson['targetCoachName']}');
//         print('   targetClubId: ${requestJson['targetClubId']}');
//         print('   targetClubName: ${requestJson['targetClubName']}');
//
//         batch.set(_joinRequests.doc(requestId), requestJson);
//         print('✅ Pupil-to-coach request added to batch');
//       }
//
//       // Create coach → club request
//       if (createClubRequest && targetClubId != null && targetClubName != null) {
//         final requestId = _joinRequests.doc().id;
//         final request = JoinRequestModel.coachToClub(
//           id: requestId,
//           coachUserId: userId,
//           coachName: userName,
//           clubId: targetClubId,
//           clubName: targetClubName,
//           message: message,
//         );
//         batch.set(_joinRequests.doc(requestId), request.toJson());
//         print('✅ Coach-to-club request added to batch');
//       }
//
//       // Create coach verification request
//       if (createVerificationRequest && userRole == 'coach') {
//         final requestId = _joinRequests.doc().id;
//         final request = JoinRequestModel.coachVerification(
//           id: requestId,
//           coachUserId: userId,
//           coachName: userName,
//           message: message,
//         );
//         batch.set(_joinRequests.doc(requestId), request.toJson());
//         print('✅ Coach verification request added to batch');
//       }
//
//       print('🚀 Committing batch...');
//       await batch.commit();
//       print('✅ Batch committed successfully!');
//     } catch (e) {
//       print('❌ Error in createJoinRequestsBatch: $e');
//       throw Exception('Failed to create join requests: $e');
//     }
//   }
//
//   /// Get all join requests for a specific user
//   Future<List<JoinRequestModel>> getRequestsForUser(String userId) async {
//     try {
//       final snapshot = await _joinRequests
//           .where('requesterId', isEqualTo: userId)
//           .orderBy('createdAt', descending: true)
//           .get();
//
//       return snapshot.docs
//           .map(
//             (doc) => JoinRequestModel.fromFirestore(
//               doc.bloc() as Map<String, dynamic>,
//             ),
//           )
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to get user requests: $e');
//     }
//   }
//
//   /// Get pending requests for admins/coaches to review
//   Future<List<JoinRequestModel>> getPendingRequestsByType(
//     String requestType,
//   ) async {
//     try {
//       final snapshot = await _joinRequests
//           .where('requestType', isEqualTo: requestType)
//           .where('status', isEqualTo: 'pending')
//           .orderBy('createdAt', descending: true)
//           .get();
//
//       return snapshot.docs
//           .map(
//             (doc) => JoinRequestModel.fromFirestore(
//               doc.bloc() as Map<String, dynamic>,
//             ),
//           )
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to get pending requests: $e');
//     }
//   }
//
//   /// Approve a join request
//   Future<void> approveRequest(
//     String requestId,
//     String reviewedBy, {
//     String? reviewNote,
//   }) async {
//     try {
//       final request = await _getRequestById(requestId);
//       final updatedRequest = request.approve(
//         reviewedBy: reviewedBy,
//         reviewNote: reviewNote,
//       );
//
//       await _joinRequests.doc(requestId).update(updatedRequest.toJson());
//     } catch (e) {
//       throw Exception('Failed to approve request: $e');
//     }
//   }
//
//   /// Reject a join request
//   Future<void> rejectRequest(
//     String requestId,
//     String reviewedBy, {
//     String? reviewNote,
//   }) async {
//     try {
//       final request = await _getRequestById(requestId);
//       final updatedRequest = request.reject(
//         reviewedBy: reviewedBy,
//         reviewNote: reviewNote,
//       );
//
//       await _joinRequests.doc(requestId).update(updatedRequest.toJson());
//     } catch (e) {
//       throw Exception('Failed to reject request: $e');
//     }
//   }
//
//   /// Private helper to get request by ID
//   Future<JoinRequestModel> _getRequestById(String requestId) async {
//     final doc = await _joinRequests.doc(requestId).get();
//     if (!doc.exists) {
//       throw Exception('Join request not found');
//     }
//     return JoinRequestModel.fromFirestore(doc.bloc() as Map<String, dynamic>);
//   }
//
//   /// Check if a specific request already exists (to prevent duplicates)
//   Future<bool> requestExists({
//     required String requesterId,
//     required String requestType,
//     String? targetCoachId,
//     String? targetClubId,
//   }) async {
//     try {
//       Query query = _joinRequests
//           .where('requesterId', isEqualTo: requesterId)
//           .where('requestType', isEqualTo: requestType)
//           .where('status', isEqualTo: 'pending');
//
//       // Add target-specific filters
//       if (targetCoachId != null) {
//         query = query.where('targetCoachId', isEqualTo: targetCoachId);
//       }
//       if (targetClubId != null) {
//         query = query.where('targetClubId', isEqualTo: targetClubId);
//       }
//
//       final snapshot = await query.limit(1).get();
//       return snapshot.docs.isNotEmpty;
//     } catch (e) {
//       // If error checking, assume doesn't exist to allow creation
//       return false;
//     }
//   }
// }
