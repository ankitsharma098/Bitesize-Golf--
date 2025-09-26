part of 'games_bloc.dart';

@immutable
abstract class GamesState extends Equatable {
  const GamesState();

  @override
  List<Object?> get props => [];
}

class GamesInitial extends GamesState {
  const GamesInitial();
}

class GamesLoading extends GamesState {
  const GamesLoading();
}

class GamesLoaded extends GamesState {
  final List<GameModel> games;

  const GamesLoaded({required this.games});

  @override
  List<Object?> get props => [games];
}

class GameDetailsLoaded extends GamesState {
  final GameModel game;

  const GameDetailsLoaded(this.game);

  @override
  List<Object?> get props => [game];
}

class GamesEmpty extends GamesState {
  final String message;

  const GamesEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

class GamesError extends GamesState {
  final String message;

  const GamesError(this.message);

  @override
  List<Object?> get props => [message];
}