import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../Models/scheduled model/scheduled_model.dart';
import '../../../../core/constants/firebase_collections_names.dart';

class PupilLessonScheduledRepo {
  Future<List<ScheduleModel>> getPupilSchedules(String pupilId) async {
    try {
      final querySnapshot = await FirestoreCollections.schedulesCol
          .where('pupilIds', arrayContains: pupilId)
          .where('status', isEqualTo: 'active')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ScheduleModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch schedules: $e');
    }
  }
}
