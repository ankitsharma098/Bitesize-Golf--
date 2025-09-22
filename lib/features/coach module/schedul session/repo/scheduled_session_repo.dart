import '../../../../Models/pupil model/pupil_model.dart';
import '../../../../Models/scheduled model/scheduled_model.dart';
import '../../../../core/constants/firebase_collections_names.dart';

class ScheduleRepository {
  Future<ScheduleModel?> getExistingSchedule({
    required String coachId,
    required int levelNumber,
  }) async {
    try {
      final querySnapshot = await FirestoreCollections.schedulesCol
          .where('coachId', isEqualTo: coachId)
          .where('levelNumber', isEqualTo: levelNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return ScheduleModel.fromFirestore(data);
    } catch (e) {
      throw Exception('Failed to check existing schedule: $e');
    }
  }

  Future<List<PupilModel>> getPupilsByCoachAndLevel({
    required String coachId,
    required int levelNumber,
  }) async {
    try {
      final querySnapshot = await FirestoreCollections.pupilsCol
          .where('assignedCoachId', isEqualTo: coachId)
          .where('currentLevel', isEqualTo: levelNumber)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID
        return PupilModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch pupils: $e');
    }
  }

  Future<String> createSchedule(ScheduleModel schedule) async {
    try {
      final docRef = await FirestoreCollections.schedulesCol.add(
        schedule.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create schedule: $e');
    }
  }

  Future<void> updateSchedule(ScheduleModel schedule) async {
    try {
      await FirestoreCollections.schedulesCol
          .doc(schedule.id)
          .update(schedule.toFirestore());
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  Future<List<ScheduleModel>> getSchedulesByCoach(String coachId) async {
    try {
      final querySnapshot = await FirestoreCollections.schedulesCol
          .where('coachId', isEqualTo: coachId)
          .orderBy('createdAt', descending: true)
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

  Future<ScheduleModel?> getScheduleById(String scheduleId) async {
    try {
      final docSnapshot = await FirestoreCollections.schedulesCol
          .doc(scheduleId)
          .get();

      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;
      return ScheduleModel.fromFirestore(data);
    } catch (e) {
      throw Exception('Failed to fetch schedule: $e');
    }
  }

  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await FirestoreCollections.schedulesCol.doc(scheduleId).delete();
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }
}
