import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../Models/level model/level_model.dart';
import '../../home/data/home_level_repo.dart'; // Assuming Firestore is used

part 'create_session_event.dart';
part 'create_session_state.dart';

class CreateSessionBloc extends Bloc<CreateSessionEvent, CreateSessionState> {
  CoachHomeRepo levelObj = CoachHomeRepo();

  CreateSessionBloc() : super(CreateSessionInitial()) {
    on<LoadLevels>(_onLoadLevels);
    on<RefreshLevels>(_onRefreshLevels);
  }

  Future<void> _onLoadLevels(
    LoadLevels event,
    Emitter<CreateSessionState> emit,
  ) async {
    emit(CreateSessionLoading());
    try {
      final levels = await levelObj.getAllLevels();
      emit(CreateSessionLoaded(levels));
    } catch (e) {
      emit(CreateSessionError('Failed to fetch levels: $e'));
    }
  }

  Future<void> _onRefreshLevels(
    RefreshLevels event,
    Emitter<CreateSessionState> emit,
  ) async {
    emit(CreateSessionLoading());
    try {
      final levels = await levelObj.getAllLevels();
      emit(CreateSessionLoaded(levels));
    } catch (e) {
      emit(CreateSessionError('Failed to fetch levels: $e'));
    }
  }
}
