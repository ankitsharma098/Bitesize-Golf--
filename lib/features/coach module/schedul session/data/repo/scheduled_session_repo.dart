import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../pupils modules/pupil/data/models/pupil_model.dart';
import '../entity/session_schedule_entity.dart';
import '../model/session_schedule_model.dart';

class ScheduleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PupilModel>> getPupilsByCoachAndLevel({
    required String coachId,
    required int levelNumber,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('pupils')
          .where('assignedCoachId', isEqualTo: coachId)
          .where('currentLevel', isEqualTo: levelNumber)
          .where('assignmentStatus', isEqualTo: 'assigned')
          .get();

      List<PupilModel> pupils = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to data
        return PupilModel.fromJson(data);
      }).toList();

      print("Pupils ${pupils.length}");

      return pupils;
    } catch (e) {
      throw Exception('Failed to fetch pupils: $e');
    }
  }

  @override
  Future<String> createSchedule(Schedule schedule) async {
    try {
      final scheduleModel = ScheduleModel.fromEntity(schedule);
      final docRef = await _firestore
          .collection('schedules')
          .add(scheduleModel.toJson());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create schedule: $e');
    }
  }

  @override
  Future<void> updateSchedule(Schedule schedule) async {
    try {
      final scheduleModel = ScheduleModel.fromEntity(schedule);
      await _firestore
          .collection('schedules')
          .doc(schedule.id)
          .update(scheduleModel.toJson());
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  @override
  Future<List<Schedule>> getSchedulesByCoach(String coachId) async {
    try {
      final querySnapshot = await _firestore
          .collection('schedules')
          .where('coachId', isEqualTo: coachId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ScheduleModel.fromFirestore(data).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch schedules: $e');
    }
  }

  @override
  Future<Schedule?> getScheduleById(String scheduleId) async {
    try {
      final docSnapshot = await _firestore
          .collection('schedules')
          .doc(scheduleId)
          .get();

      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;
      return ScheduleModel.fromFirestore(data).toEntity();
    } catch (e) {
      throw Exception('Failed to fetch schedule: $e');
    }
  }

  @override
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await _firestore.collection('schedules').doc(scheduleId).delete();
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }
}
