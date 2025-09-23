part of 'create_session_bloc.dart';

abstract class CreateSessionEvent extends Equatable {
  const CreateSessionEvent();

  @override
  List<Object> get props => [];
}

class LoadLevels extends CreateSessionEvent {}

class RefreshLevels extends CreateSessionEvent {}
