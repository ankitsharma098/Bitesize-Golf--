import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'challenges_event.dart';
part 'challenges_state.dart';

class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  ChallengesBloc() : super(ChallengesInitial()) {
    on<ChallengesEvent>((event, emit) {
    });
  }
}
