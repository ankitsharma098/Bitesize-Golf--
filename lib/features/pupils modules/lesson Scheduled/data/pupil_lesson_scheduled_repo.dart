import 'package:bitesize_golf/features/coach%20module/schedul%20session/data/model/session_schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../coach module/schedul session/data/entity/session_schedule_entity.dart';

class PupilLessonScheduledRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ScheduleModel>> getPupilSchedules(String pupilId) async {
    try {
      final querySnapshot = await _firestore
          .collection('schedules')
          .where('pupilIds', arrayContains: pupilId)
          .where('status', isEqualTo: 'active')
          .get();

      return querySnapshot.docs
          .map((doc) => ScheduleModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch schedules: $e');
    }
  }
}
