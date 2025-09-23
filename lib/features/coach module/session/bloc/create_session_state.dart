part of 'create_session_bloc.dart';

abstract class CreateSessionState extends Equatable {
  const CreateSessionState();

  @override
  List<Object> get props => [];
}

class CreateSessionInitial extends CreateSessionState {}

class CreateSessionLoading extends CreateSessionState {}

class CreateSessionLoaded extends CreateSessionState {
  final List<LevelModel> levels;

  const CreateSessionLoaded(this.levels);

  @override
  List<Object> get props => [levels];
}

class CreateSessionError extends CreateSessionState {
  final String message;

  const CreateSessionError(this.message);

  @override
  List<Object> get props => [message];
}
