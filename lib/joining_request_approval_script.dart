import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/join_request_models.dart';

/// Admin Script for Managing Join Requests
/// Run this script to approve/reject join requests without an admin panel
class AdminJoinRequestScript {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _joinRequests =>
      _firestore.collection('joinRequests');
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _pupils => _firestore.collection('pupils');
  CollectionReference get _coaches => _firestore.collection('coaches');
  CollectionReference get _clubs => _firestore.collection('clubs');

  /// View all pending requests

  /// View requests by type
  Future<void> viewRequestsByType(String requestType) async {
    try {
      print('\n🔍 FETCHING $requestType REQUESTS...\n');

      final snapshot = await _joinRequests
          .where('requestType', isEqualTo: requestType)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        print('✅ No pending $requestType requests found!');
        return;
      }

      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        final request = JoinRequestModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
        );

        print(
          '${i + 1}. ${request.requesterName} → ${_getTargetInfo(request)}',
        );
        print('   ID: ${request.id}');
        print('   Message: ${request.message ?? 'No message'}');
        print('   Date: ${request.requestedAt}');
        print('   ---');
      }
    } catch (e) {
      print('❌ Error fetching $requestType requests: $e');
    }
  }

  /// Approve a specific request by ID
  Future<void> approveRequest(
    String requestId, {
    String adminId = 'admin_script',
    String? reviewNote,
  }) async {
    try {
      print('\n✅ APPROVING REQUEST: $requestId\n');

      // Get the request
      final requestDoc = await _joinRequests.doc(requestId).get();
      if (!requestDoc.exists) {
        print('❌ Request not found!');
        return;
      }

      final request = JoinRequestModel.fromFirestore(
        requestDoc.data() as Map<String, dynamic>,
      );

      if (request.status != 'pending') {
        print('❌ Request is not pending! Current status: ${request.status}');
        return;
      }

      // Start transaction for approval
      await _firestore.runTransaction((transaction) async {
        // Update request status
        final updatedRequest = request.approve(
          reviewedBy: adminId,
          reviewNote: reviewNote ?? 'Approved via admin script',
        );

        transaction.update(
          _joinRequests.doc(requestId),
          updatedRequest.toJson(),
        );

        // Handle different request types
        await _handleRequestApproval(transaction, request);
      });

      print('✅ Request approved successfully!');
      print('   Type: ${request.requestType}');
      print('   Requester: ${request.requesterName}');
      print('   Target: ${_getTargetInfo(request)}');
    } catch (e) {
      print('❌ Error approving request: $e');
    }
  }

  /// Reject a specific request by ID
  Future<void> rejectRequest(
    String requestId, {
    String adminId = 'admin_script',
    String? reviewNote,
  }) async {
    try {
      print('\n❌ REJECTING REQUEST: $requestId\n');

      // Get the request
      final requestDoc = await _joinRequests.doc(requestId).get();
      if (!requestDoc.exists) {
        print('❌ Request not found!');
        return;
      }

      final request = JoinRequestModel.fromFirestore(
        requestDoc.data() as Map<String, dynamic>,
      );

      if (request.status != 'pending') {
        print('❌ Request is not pending! Current status: ${request.status}');
        return;
      }

      // Update request status
      final updatedRequest = request.reject(
        reviewedBy: adminId,
        reviewNote: reviewNote ?? 'Rejected via admin script',
      );

      await _joinRequests.doc(requestId).update(updatedRequest.toJson());

      print('✅ Request rejected successfully!');
      print('   Type: ${request.requestType}');
      print('   Requester: ${request.requesterName}');
      print('   Reason: ${reviewNote ?? 'No reason provided'}');
    } catch (e) {
      print('❌ Error rejecting request: $e');
    }
  }

  /// Bulk approve all requests of a specific type
  Future<void> bulkApproveByType(
    String requestType, {
    String adminId = 'admin_script',
    String? reviewNote,
  }) async {
    try {
      print('\n🚀 BULK APPROVING ALL $requestType REQUESTS...\n');

      final snapshot = await _joinRequests
          .where('requestType', isEqualTo: requestType)
          .where('status', isEqualTo: 'pending')
          .get();

      if (snapshot.docs.isEmpty) {
        print('✅ No pending $requestType requests to approve!');
        return;
      }

      print('Found ${snapshot.docs.length} requests to approve...');

      int successCount = 0;
      int errorCount = 0;

      for (final doc in snapshot.docs) {
        try {
          final request = JoinRequestModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
          );

          await _firestore.runTransaction((transaction) async {
            final updatedRequest = request.approve(
              reviewedBy: adminId,
              reviewNote: reviewNote ?? 'Bulk approved via admin script',
            );

            transaction.update(
              _joinRequests.doc(request.id),
              updatedRequest.toJson(),
            );
            await _handleRequestApproval(transaction, request);
          });

          successCount++;
          print(
            '✅ Approved: ${request.requesterName} → ${_getTargetInfo(request)}',
          );
        } catch (e) {
          errorCount++;
          print('❌ Failed to approve request ${doc.id}: $e');
        }
      }

      print('\n📊 BULK APPROVAL RESULTS:');
      print('✅ Successful: $successCount');
      print('❌ Failed: $errorCount');
      print('📋 Total: ${snapshot.docs.length}');
    } catch (e) {
      print('❌ Error in bulk approval: $e');
    }
  }

  /// Handle specific approval logic for different request types
  Future<void> _handleRequestApproval(
    Transaction transaction,
    JoinRequestModel request,
  ) async {
    switch (request.requestType) {
      case 'pupil_to_coach':
        await _handlePupilToCoachApproval(transaction, request);
        break;
      case 'coach_to_club':
        await _handleCoachToClubApproval(transaction, request);
        break;
      case 'coach_verification':
        await _handleCoachVerificationApproval(transaction, request);
        break;
      default:
        print('⚠️  Unknown request type: ${request.requestType}');
    }
  }

  /// Handle pupil to coach approval
  /// Handle pupil to coach approval
  Future<void> _handlePupilToCoachApproval(
    Transaction transaction,
    JoinRequestModel request,
  ) async {
    // Update pupil document with assigned coach AND club info
    final updateData = <String, dynamic>{
      'assignedCoachId': request.targetCoachId,
      'assignedCoachName': request.targetCoachName,
      'coachAssignedAt': FieldValue.serverTimestamp(),
      'coachAssignmentStatus': 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Add club information if present in the request
    if (request.targetClubId != null && request.targetClubName != null) {
      updateData.addAll({
        'assignedClubId': request.targetClubId,
        'assignedClubName': request.targetClubName,
        'clubAssignedAt': FieldValue.serverTimestamp(),
        'clubAssignmentStatus': 'active',
      });

      print(
        '🏌️ Also assigning ${request.requesterName} to club ${request.targetClubName}',
      );
    }

    transaction.update(_pupils.doc(request.requesterId), updateData);

    // Update coach document to increment pupil count
    transaction.update(_coaches.doc(request.targetCoachId), {
      'currentPupils': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Optionally update club's pupil count if club info exists
    if (request.targetClubId != null) {
      transaction.update(_clubs.doc(request.targetClubId!), {
        'totalPupils': FieldValue.increment(1),
        'activePupils': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    print(
      '🎯 Assigned ${request.requesterName} to coach ${request.targetCoachName}',
    );
  }

  /// Helper to get target info string - UPDATED to show club info
  String _getTargetInfo(JoinRequestModel request) {
    switch (request.requestType) {
      case 'pupil_to_coach':
        String info = 'Coach: ${request.targetCoachName ?? 'Unknown'}';
        if (request.targetClubId != null) {
          info += ' at ${request.targetClubName ?? 'Unknown Club'}';
        }
        return info;
      case 'coach_to_club':
        return 'Club: ${request.targetClubName ?? 'Unknown'}';
      case 'coach_verification':
        return 'Admin Verification';
      default:
        return 'Unknown Target';
    }
  }

  /// Enhanced view method to show club information
  /// Enhanced view method to show club information
  Future<void> viewAllPendingRequests() async {
    try {
      print('\n🔍 FETCHING ALL PENDING REQUESTS...\n');

      final snapshot = await _joinRequests
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        print('✅ No pending requests found!');
        return;
      }

      print('📋 PENDING REQUESTS (${snapshot.docs.length}):\n');

      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        final request = JoinRequestModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
        );

        print('${i + 1}. REQUEST ID: ${request.id}');
        print('   Type: ${request.requestType}');
        print(
          '   Requester: ${request.requesterName} (${request.requesterRole})',
        );
        print('   Target: ${_getTargetInfo(request)}');

        // Show additional details for pupil requests
        if (request.requestType == 'pupil_to_coach') {
          print('   Coach ID: ${request.targetCoachId}');
          if (request.targetClubId != null) {
            print('   Club ID: ${request.targetClubId}');
          }
        }

        print('   Message: ${request.message ?? 'No message'}');
        print('   Requested: ${request.requestedAt}');
        print('   Status: ${request.status}');
        print('   ---');
      }
    } catch (e) {
      print('❌ Error fetching requests: $e');
    }
  }

  /// Add a method to specifically handle pupil-coach-club assignments
  Future<void> approveRequestWithClubAssignment(
    String requestId, {
    String adminId = 'admin_script',
    String? reviewNote,
    bool assignToClub = true,
  }) async {
    try {
      print('\n✅ APPROVING REQUEST WITH CLUB ASSIGNMENT: $requestId\n');

      final requestDoc = await _joinRequests.doc(requestId).get();
      if (!requestDoc.exists) {
        print('❌ Request not found!');
        return;
      }

      final request = JoinRequestModel.fromFirestore(
        requestDoc.data() as Map<String, dynamic>,
      );

      if (request.status != 'pending') {
        print('❌ Request is not pending! Current status: ${request.status}');
        return;
      }

      if (request.requestType != 'pupil_to_coach') {
        print('❌ This method is only for pupil-to-coach requests!');
        return;
      }

      await _firestore.runTransaction((transaction) async {
        // Update request status
        final updatedRequest = request.approve(
          reviewedBy: adminId,
          reviewNote:
              reviewNote ?? 'Approved with club assignment via admin script',
        );

        transaction.update(
          _joinRequests.doc(requestId),
          updatedRequest.toJson(),
        );

        // Handle approval with explicit club assignment
        await _handlePupilToCoachApproval(transaction, request);
      });

      print('✅ Request approved successfully with club assignment!');
      print('   Pupil: ${request.requesterName}');
      print('   Coach: ${request.targetCoachName}');
      if (request.targetClubName != null) {
        print('   Club: ${request.targetClubName}');
      }
    } catch (e) {
      print('❌ Error approving request with club assignment: $e');
    }
  }

  /// Handle coach to club approval
  Future<void> _handleCoachToClubApproval(
    Transaction transaction,
    JoinRequestModel request,
  ) async {
    // Update coach document with assigned club
    transaction.update(_coaches.doc(request.requesterId), {
      'assignedClubId': request.targetClubId,
      'assignedClubName': request.targetClubName,
      'clubAssignedAt': FieldValue.serverTimestamp(),
      'clubAssignmentStatus': 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // You might also want to update club document to add coach
    // transaction.update(_clubs.doc(request.targetClubId), {
    //   'coachIds': FieldValue.arrayUnion([request.requesterId]),
    //   'updatedAt': FieldValue.serverTimestamp(),
    // });

    print(
      '🏌️ Assigned coach ${request.requesterName} to club ${request.targetClubName}',
    );
  }

  /// Handle coach verification approval
  Future<void> _handleCoachVerificationApproval(
    Transaction transaction,
    JoinRequestModel request,
  ) async {
    // Update coach document verification status
    transaction.update(_coaches.doc(request.requesterId), {
      'verificationStatus': 'verified',
      'verifiedBy': request.reviewedBy,
      'verifiedAt': FieldValue.serverTimestamp(),
      'verificationNote': request.reviewNote,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    print('✅ Verified coach ${request.requesterName}');
  }

  /// Helper to get target info string

  /// Quick approve all coach verifications (common admin task)
  Future<void> quickApproveAllCoachVerifications() async {
    await bulkApproveByType(
      'coach_verification',
      reviewNote: 'Auto-approved: Initial coach verification',
    );
  }

  /// Quick view summary
  Future<void> viewSummary() async {
    try {
      print('\n📊 JOIN REQUESTS SUMMARY\n');

      // Count by type and status
      final allRequests = await _joinRequests.get();

      Map<String, Map<String, int>> summary = {};

      for (final doc in allRequests.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final type = data['requestType'] as String? ?? 'unknown';
        final status = data['status'] as String? ?? 'unknown';

        summary[type] ??= {};
        summary[type]![status] = (summary[type]![status] ?? 0) + 1;
      }

      for (final type in summary.keys) {
        print('$type:');
        for (final status in summary[type]!.keys) {
          print('  $status: ${summary[type]![status]}');
        }
        print('');
      }
    } catch (e) {
      print('❌ Error generating summary: $e');
    }
  }
}

/// Usage Example:
///
