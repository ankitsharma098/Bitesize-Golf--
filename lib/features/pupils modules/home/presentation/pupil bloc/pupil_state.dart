import 'package:equatable/equatable.dart';
import '../../../pupil/data/models/pupil_model.dart';

abstract class PupilState extends Equatable {
  const PupilState();

  @override
  List<Object?> get props => [];
}

class PupilInitial extends PupilState {}

class PupilLoading extends PupilState {}

class PupilLoaded extends PupilState {
  final PupilModel pupil;

  const PupilLoaded(this.pupil);

  @override
  List<Object?> get props => [pupil];
}

class PupilError extends PupilState {
  final String message;

  const PupilError(this.message);

  @override
  List<Object?> get props => [message];
}
